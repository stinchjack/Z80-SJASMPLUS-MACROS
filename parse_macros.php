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
    // Build markdown header
    $md = "# " . basename($filename) . "\n\n";

    if (!empty($fileHeader['Description'])) {
        $md .= "## Description\n\n" . trim($fileHeader['Description']) . "\n\n";
    }

    if (!empty($fileHeader['Key Points'])) {
        $md .= "## Key Points\n\n" . trim($fileHeader['Key Points']) . "\n\n";
    }

    // Markdown table header with Description column added
    $md .= "| Macro name | Parameters | Description | Side effects | Usage | Z80 Equivalent | Notes |\n";
    $md .= "|------------|------------|-------------|--------------|-------|----------------|-------|\n";

    // Escape and format each field
    $format = fn($text) => str_replace(["|", "\n", "\r"], ["\\|", "<br>", ""], trim((string) $text));

    foreach ($macros as $macroName => $info) {
        $md .= "| " . $format($macroName)
             . " | " . $format($info['Parameters'] ?? '')
             . " | " . $format($info['Description'] ?? '')
             . " | " . $format($info['Side effects'] ?? '')
             . " | " . $format($info['Usage'] ?? '')
             . " | " . $format($info['Z80 Equivalent'] ?? '')
             . " | " . $format($info['Notes'] ?? '') . " |\n";
    }

    return $md;
}

function generate_html(array $fileHeader, array $macros, string $filename): string {
    $fileAnchorPrefix = strtolower(str_replace([' ', '.', '_'], '-', basename($filename, '.asm')));
    $html = "<h2>" . htmlspecialchars(basename($filename)) . "</h2>\n";

    if (!empty($fileHeader['Description'])) {
        $html .= "<h3>Description</h3>\n<p>" . nl2br(htmlspecialchars($fileHeader['Description'])) . "</p>\n";
    }

    if (!empty($fileHeader['Key Points'])) {
        $html .= "<h3>Key Points</h3>\n<p>" . nl2br(htmlspecialchars($fileHeader['Key Points'])) . "</p>\n";
    }

    $html .= "<table border=\"1\" cellspacing=\"0\" cellpadding=\"5\">\n";
    $html .= "<thead>\n<tr>"
           . "<th>Macro name</th>"
           . "<th>Parameters</th>"
           . "<th>Description</th>"
           . "<th>Side effects</th>"
           . "<th>Usage</th>"
           . "<th>Z80 Equivalent</th>"
           . "<th>Notes</th>"
           . "</tr>\n</thead>\n<tbody>\n";

    foreach ($macros as $macroName => $info) {
        // Generate a unique anchor like: math-abs
        $macroAnchor = $fileAnchorPrefix . '-' . strtolower($macroName);
        $html .= "<tr>"
               . "<td><a id=\"$macroAnchor\"></a>" . htmlspecialchars($macroName) . "</td>"
               . "<td>" . nl2br(htmlspecialchars($info['Parameters'] ?? '')) . "</td>"
               . "<td>" . nl2br(htmlspecialchars($info['Description'] ?? '')) . "</td>"
               . "<td>" . nl2br(htmlspecialchars($info['Side effects'] ?? '')) . "</td>"
               . "<td>" . nl2br(htmlspecialchars($info['Usage'] ?? '')) . "</td>"
               . "<td>" . nl2br(htmlspecialchars($info['Z80 Equivalent'] ?? '')) . "</td>"
               . "<td>" . nl2br(htmlspecialchars($info['Notes'] ?? '')) . "</td>"
               . "</tr>\n";
    }

    $html .= "</tbody>\n</table>\n";

    return $html;
}

function generate_combined_markdown(string $directory = '.', string $exclude = 'sjasmplus-macros.inc.asm', string $outputFile = 'combined_macros.md') {
    $allMarkdown = "# Z80 Macro Reference\n\n";

    foreach (glob("$directory/*.asm") as $file) {
        if (basename($file) === $exclude) {
            continue;
        }

        $header = parse_file_header($file);
        $macros = parse_asm_macros($file);
        $markdown = generate_markdown($header, $macros, $file);
        $allMarkdown .= $markdown . "\n\n";
    }

    file_put_contents($outputFile, $allMarkdown);
    echo "Combined Markdown saved to $outputFile\n";
}

function generate_combined_html(string $directory = '.', string $exclude = 'sjasmplus-macros.inc.asm', string $outputFile = 'combined_macros.html') {
    $allHtml = "";

    foreach (glob("$directory/*.asm") as $file) {
        if (basename($file) === $exclude) {
            continue;
        }

        $header = parse_file_header($file);
        $macros = parse_asm_macros($file);
        $html = generate_html($header, $macros, $file);
        $allHtml .= $html . "<hr>\n";
    }


    return $allHtml;
}


function prepend_macro_index_to_html(string $htmlContent): string {
    $pattern = '/<td><a id="([^"]+)"><\/a>([^<]*)<\/td>/i';
    preg_match_all($pattern, $htmlContent, $matches, PREG_SET_ORDER);

    $macroEntries = [];

    foreach ($matches as $match) {
        $anchor = $match[1];            // e.g., "math-abs"
        $macroName = trim($match[2]);   // e.g., "ABS"

        if ($macroName === '') {
            continue;
        }

        // Try to extract filename from anchor
        if (preg_match('/^(.+)-([a-zA-Z0-9_]+)$/', $anchor, $parts)) {
            $file = $parts[1];
        } else {
            $file = '?';
        }

        $macroEntries[$macroName] = [
            'anchor' => $anchor,
            'file' => $file,
        ];
    }

    // Sort by macro name
    ksort($macroEntries, SORT_NATURAL | SORT_FLAG_CASE);

    // Build the index HTML
    $index = "<h1>Z80 Macro Reference</h1>\n";
    $index .= "<h2>Macro Index (A–Z)</h2>\n<ul>\n";

    foreach ($macroEntries as $macroName => $info) {
        $index .= "<li><a href=\"#{$info['anchor']}\">" . htmlspecialchars($macroName) . "</a> "
                . "<small>(" . htmlspecialchars($info['file']) . ")</small></li>\n";
    }

    $index .= "</ul>\n<hr>\n";

    return $index . $htmlContent;
}

$html = generate_combined_html();
$finalHtml = prepend_macro_index_to_html($html);
file_put_contents('combined_macros.html', $finalHtml);
echo "Final HTML with macro index saved to combined_macros.html\n";
