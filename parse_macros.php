<?php

function parse_file_header(string $filename): array {
    $contents = file_get_contents($filename);
    $lines = explode("\n", $contents);
    $headerBlock = [];

    foreach ($lines as $line) {
        $trimmed = trim($line);

        // Stop parsing header at start of macros or definitions
        if (preg_match('/^\s*(MACRO|IFNDEF|DEFINE)/i', $trimmed)) {
            break;
        }

        // Only keep comment lines
        if (preg_match('/^\s*;/', $trimmed)) {
            $comment = preg_replace('/^\s*;\s?/', '', $trimmed);

            // Ignore decorative lines (only = or - repeated)
            if (preg_match('/^[-=]{5,}$/', $comment)) {
                continue;
            }

            $headerBlock[] = $comment;
        }
    }

    // Now extract specific sections
    $fields = [
        'Description' => '',
        'Key Points' => '',
    ];

    $currentField = null;
    $buffer = [];

    foreach ($headerBlock as $line) {
        if (preg_match('/^(Description|Key Points):\s*(.*)$/i', $line, $m)) {
            // Save previous field if we had one
            if ($currentField && $buffer) {
                $fields[$currentField] = trim(implode("\n", $buffer));
                $buffer = [];
            }

            $currentField = $m[1];
            $buffer[] = $m[2];
        } elseif ($currentField) {
            $buffer[] = $line;
        }
    }

    // Save last buffer
    if ($currentField && $buffer) {
        $fields[$currentField] = trim(implode("\n", $buffer));
    }

    return $fields;
}

function parse_asm_macros(string $filename): array {
    $contents = file_get_contents($filename);

    $macros = [];

    // Match all macro blocks with their preceding comments
    $pattern = '/((?:\s*;[^\n]*\n)+)\s*MACRO\s+([a-zA-Z0-9_]+)[\s\S]*?ENDM/s';
    preg_match_all($pattern, $contents, $matches, PREG_SET_ORDER);

    foreach ($matches as $match) {
        $commentBlock = $match[1];
        $macroName = trim($match[2]);

        // Initialize fields
        $fields = [
            'Parameters'     => '',
            'Description'    => '',
            'Side effects'   => '',
            'Usage'          => '',
            'Z80 Equivalent' => '',
            'Notes'          => '',
        ];

        $lines = explode("\n", $commentBlock);
        $currentField = null;
        $buffer = [];

        foreach ($lines as $line) {
            $line = trim($line);
            $line = preg_replace('/^;\s?/', '', $line); // remove `;` and optional space

            // Skip visual divider lines
            if (preg_match('/^[-=]{5,}$/', $line)) {
                continue;
            }

            // Skip macro header line like "MIN_UNSIGNED_A_VAL val"
            if ($currentField === null && preg_match('/^[A-Z0-9_]+(\s+\S.*)?$/', $line)) {
                continue;
            }

            // Match known field headings
            if (preg_match('/^(Parameters|Description|Side effects|Usage|Z80 Equivalent):\s*(.*)$/i', $line, $m)) {
                // Save previous field
                if ($currentField && count($buffer)) {
                    $fields[$currentField] = trim(implode("\n", $buffer));
                    $buffer = [];
                }
                $currentField = $m[1];
                $buffer[] = $m[2]; // first line of value
            } elseif ($currentField) {
                $buffer[] = $line;
            } else {
                $fields['Notes'] .= $line . "\n";
            }
        }

        // Save last buffered field
        if ($currentField && count($buffer)) {
            $fields[$currentField] = trim(implode("\n", $buffer));
        }

        $fields['Notes'] = trim($fields['Notes']);
        if ($fields['Notes'] === '') {
            unset($fields['Notes']);
        }

        $macros[$macroName] = $fields;
    }

    return $macros;
}


function generate_markdown(array $fileHeader, array $macros, string $filename): string {
    // Build markdown header with Description and Key Points
    $md = "# " . basename($filename) . "\n\n";

    if (!empty($fileHeader['Description'])) {
        $md .= "## Description\n\n";
        $md .= $fileHeader['Description'] . "\n\n";
    }

    if (!empty($fileHeader['Key Points'])) {
        $md .= "## Key Points\n\n";
        $md .= $fileHeader['Key Points'] . "\n\n";
    }

    // Table header
    $md .= "| Macro name | Parameters | Side effects | Usage | Z80 Equivalent | Notes |\n";
    $md .= "|------------|------------|--------------|-------|----------------|-------|\n";

    // Add each macro row
    foreach ($macros as $macroName => $info) {
        // Escape pipe characters inside fields (| breaks markdown tables)
        $escape = fn($text) => str_replace('|', '\\|', trim($text));

        $md .= "| " . $escape($macroName) . " "
            . "| " . $escape($info['Parameters'] ?? '') . " "
            . "| " . $escape($info['Side effects'] ?? '') . " "
            . "| " . $escape($info['Usage'] ?? '') . " "
            . "| " . $escape($info['Z80 Equivalent'] ?? '') . " "
            . "| " . $escape($info['Notes'] ?? '') . " |\n";
    }

    return $md;
}

// Example usage:
$asmFile = '8-bit-conditional-branch.macro.asm'; // Adjust path to your .asm file

$fileHeader = parse_file_header($asmFile);
$macros = parse_asm_macros($asmFile);  // your existing macro parser function

$markdown = generate_markdown($fileHeader, $macros, '$asmFile');

file_put_contents("8-bit-conditional-branch.macro.md", $markdown);
