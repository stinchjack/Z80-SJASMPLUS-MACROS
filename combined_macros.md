# Z80 Macro Reference

# 8-bit-conditional-branch.macro.asm

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


# 8-bit-maths.macros.asm

## Description

A collection of assembly macros for Z80 8-bit arithmetic operations using
  SJASMPlus syntax. These macros simplify common patterns for manipulating
  8-bit values in registers and memory.

Usage:
  INCLUDE "8-bit-maths-macros.inc"

## Key Points

These macros work only on 8-bit values

Some macros modify register A and flags

Macros using IX offsets assume signed offsets (-128..127)

ADD_ADDR_REG does NOT accept A as reg parameter

| Macro name | Parameters | Description | Side effects | Usage | Z80 Equivalent | Notes |
|------------|------------|-------------|--------------|-------|----------------|-------|
| MIN_UNSIGNED_A_VAL | val - immediate 8-bit unsigned constant | Clamp register A to a minimum value (A = max(A, val)).<br>  If A < val, then A is set to val. | Modifies register A and flags (AF register pair). | MIN_UNSIGNED_A_VAL 42 |  |  |
| MAX_UNSIGNED_A_VAL | val - immediate 8-bit unsigned constant | Clamp register A to a maximum value (A = min(A, val)).<br>  If A > val, then A is set to val. | Modifies register A and flags (AF register pair). | MAX_UNSIGNED_A_VAL 200 |  |  |
| ADD_ADDR_REG | addr - memory address (label or direct)<br>  reg  - 8-bit register (not A) | Adds the value of register 'reg' to the byte at memory location 'addr'.<br>  (addr) += reg. Does NOT work with A register | Modifies register A and flags. | ADD_ADDR_REG myVar, b | add (addr), r |  |
| ADD_ADDR_ADDR | addr1 - destination memory address<br>  addr2 - source memory address | Adds the byte at addr2 to the byte at addr1 and stores the result in addr1.<br>  (addr1) += (addr2) | Uses register A and HL; pushes and pops HL. | ADD_ADDR_ADDR var1, var2 | add (addr1), (addr2) |  |
| ADD_IX | idx1 - IX offset destination (signed 8-bit)<br>  idx2 - IX offset source (signed 8-bit) | Adds the value at (IX + idx2) to the value at (IX + idx1).<br>  (IX+idx1) += (IX+idx2) | Modifies register A and flags. | ADD_IX 0, 1 | add (ix+idx1), (ix+idx2) |  |
| SUM_IX | idx1 - IX offset destination (signed 8-bit)<br>  idx2 - IX offset source 1 (signed 8-bit)<br>  idx3 - IX offset source 2 (signed 8-bit) | Computes the sum of bytes at (IX+idx2) and (IX+idx3) and stores it in (IX+idx1).<br>  (IX+idx1) = (IX+idx2) + (IX+idx3) | Modifies register A and flags. | SUM_IX 0, 1, 2 | ld (ix+idx1), (ix+idx2)<br>  add (ix+idx3) |  |
| NEG8_IXPLUS | n - signed 8-bit IX offset | Negates the value at (IX + n).<br>  (IX+n) = - (IX+n) | Uses registers A and flags. | NEG8_IXPLUS -3 |  |  |
| ABS8_IXPLUS | n - signed 8-bit IX offset | Replaces the value at (IX+n) with its absolute value (treating it as signed).<br>  (IX+n) = abs((IX+n)) | Uses registers A and flags. | ABS8_IXPLUS 5 |  |  |
| ABS8_A | none | Converts register A to its absolute value (if signed). | Modifies register A and flags. | ABS8_A |  |  |
| ABS8_HLPTR | none | Converts the byte pointed to by HL to its absolute value (if signed).<br>  (HL) = abs((HL)) | Uses register A and flags. | ABS8_HLPTR |  |  |
| ABS8_DEPTR | none | Converts the byte pointed to by DE to its absolute value (if signed).<br>  (DE) = abs((DE)) | Uses registers A and HL; swaps HL and DE temporarily.<br>  Uses flags. | ABS8_DEPTR |  |  |


