# $asmFile

## Description

A collection of assembly macros for Z80 8-bit conditional branching and
  flow control using SJASMPlus syntax. These macros encapsulate conditional
  logic based on comparisons of register A and memory values.

Usage:
  INCLUDE "8-bit-conditional-branch.macro.asm"

## Key Points

All macros perform comparisons only against register A or memory pointed by HL.

The CP instruction is used internally, so flags are affected.

Macros using (HL) read from memory and load value into A, affecting A.

Branch/call/ret destinations accept labels or addresses.

Signed macros carefully handle signed overflow and sign bits.

These macros only deal with 8-bit values.

| Macro name | Parameters | Description | Side effects | Usage | Z80 Equivalent | Notes |
|------------|------------|-------------|--------------|-------|----------------|-------|
| BRANCH_IF_A_EQU | val     - 8-bit immediate value to compare with A<br>  address - label or address to jump to if condition is met | Branches to 'address' if the value in register A equals 'val'. | Modifies flags due to CP instruction. | BRANCH_IF_A_EQU 42, Label_Equal |  |  |
| BRANCH_IF_A_NOT_EQU | val     - 8-bit immediate value to compare with A<br>  address - label or address to jump to if condition is met | Branches to 'address' if the value in register A is not equal to 'val'. | Modifies flags due to CP instruction. | BRANCH_IF_A_NOT_EQU 10, Label_NotEqual |  |  |
| BRANCH_HLPTR_EQU | val  - 8-bit immediate value to compare with (HL)<br>  addr - label or address to jump to if condition is met | Branches to 'addr' if the byte at memory address pointed by HL equals 'val'. | Uses register A; modifies flags. | BRANCH_HLPTR_EQU 0xFF, Label_HLMatch |  |  |
| BRANCH_HLPTR_NOT_EQU | val  - 8-bit immediate value to compare with (HL)<br>  addr - label or address to jump to if condition is met | Branches to 'addr' if the byte at memory address pointed by HL is not equal to 'val'. | Uses register A; modifies flags. | BRANCH_HLPTR_NOT_EQU 0x00, Label_HLNotMatch |  |  |
| BRANCH_UNSIGNED_A_LTE_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to jump if A <= v (unsigned) | Branches to 'dest' if register A is less than or equal to v (unsigned comparison). | Modifies flags. | BRANCH_UNSIGNED_A_LTE_V 100, Label_LE_100 |  |  |
| BRANCH_UNSIGNED_A_LT_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to jump if A < v (unsigned) | Branches to 'dest' if register A is less than v (unsigned comparison). | Modifies flags. | BRANCH_UNSIGNED_A_LT_V 50, Label_LT_50 |  |  |
| BRANCH_UNSIGNED_A_GTE_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to jump if A >= v (unsigned) | Branches to 'dest' if register A is greater than or equal to v (unsigned comparison). | Modifies flags. | BRANCH_UNSIGNED_A_GTE_V 200, Label_GTE_200 |  |  |
| BRANCH_UNSIGNED_A_GT_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to jump if A > v (unsigned) | Branches to 'dest' if register A is greater than v (unsigned comparison). | Modifies flags. | BRANCH_UNSIGNED_A_GT_V 150, Label_GT_150 |  |  |
| RET_UNSIGNED_A_LTE_V | v - 8-bit unsigned immediate value | Returns from subroutine if A <= v (unsigned comparison). | Modifies flags. | RET_UNSIGNED_A_LTE_V 42 |  |  |
| RET_UNSIGNED_A_LT_V | v - 8-bit unsigned immediate value | Returns from subroutine if A < v (unsigned comparison). | Modifies flags. | RET_UNSIGNED_A_LT_V 10 |  |  |
| RET_UNSIGNED_A_GTE_V | v - 8-bit unsigned immediate value | Returns from subroutine if A >= v (unsigned comparison). | Modifies flags. | RET_UNSIGNED_A_GTE_V 100 |  |  |
| RET_UNSIGNED_A_GT_V | v - 8-bit unsigned immediate value | Returns from subroutine if A > v (unsigned comparison). | Modifies flags. | RET_UNSIGNED_A_GT_V 200 |  |  |
| CALL_UNSIGNED_A_LTE_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to call if A <= v (unsigned) | Calls subroutine at 'dest' if A <= v (unsigned comparison). | Modifies flags. | CALL_UNSIGNED_A_LTE_V 50, SomeSubroutine |  |  |
| CALL_UNSIGNED_A_LT_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to call if A < v (unsigned) | Calls subroutine at 'dest' if A < v (unsigned comparison). | Modifies flags. | CALL_UNSIGNED_A_LT_V 10, SomeSubroutine |  |  |
| CALL_UNSIGNED_A_GTE_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to call if A >= v (unsigned) | Calls subroutine at 'dest' if A >= v (unsigned comparison). | Modifies flags. | CALL_UNSIGNED_A_GTE_V 100, SomeSubroutine |  |  |
| CALL_UNSIGNED_A_GT_V | v    - 8-bit unsigned immediate value<br>  dest - label or address to call if A > v (unsigned) | Calls subroutine at 'dest' if A > v (unsigned comparison). | Modifies flags. | CALL_UNSIGNED_A_GT_V 200, SomeSubroutine |  |  |
| BRANCH_SIGNED_A_GT_V | v    - 8-bit signed immediate value<br>  dest - label or address to jump if A > v (signed) | Branches to 'dest' if register A is greater than v considering signed comparison.<br>  This macro accounts for signed overflow and sign bits in the comparison. | Modifies flags. | BRANCH_SIGNED_A_GT_V -10, Label_SignedGT |  |  |
| BRANCH_SIGNED_A_GTE_V | v    - 8-bit signed immediate value<br>  dest - label or address to jump if A >= v (signed) | Branches to 'dest' if register A is greater than or equal to v considering signed comparison.<br>  Handles overflow and sign bits. | Modifies flags. | BRANCH_SIGNED_A_GTE_V -5, Label_SignedGTE |  |  |
| BRANCH_SIGNED_A_LT_V | v    - 8-bit signed immediate value<br>  dest - label or address to jump if A < v (signed) | Branches to 'dest' if register A is less than v considering signed comparison.<br>  Handles overflow and sign bits. | Modifies flags. | BRANCH_SIGNED_A_LT_V 10, Label_SignedLT |  |  |
| BRANCH_SIGNED_A_LTE_V | v    - 8-bit signed immediate value<br>  dest - label or address to jump if A <= v (signed) | Branches to 'dest' if register A is less than or equal to v considering signed comparison.<br>  Handles overflow and sign bits. | Modifies flags. | BRANCH_SIGNED_A_LTE_V 0, Label_SignedLTE |  |  |
