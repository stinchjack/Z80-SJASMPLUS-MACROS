; ============================================================================
; Z80 8-bit Conditional Branching Macros for SJASMPlus
; Author: Jack Stinchcombe
; License: MIT
;
; Description:
;   A collection of assembly macros for Z80 8-bit conditional branching and
;   flow control using SJASMPlus syntax. These macros encapsulate conditional
;   logic based on comparisons of register A and memory values.
;
; Usage:
;   INCLUDE "8-bit-conditional-branch.macro.asm"
;
; Key Points:
; All macros perform comparisons only against register A or memory pointed by HL.
;
; The CP instruction is used internally, so flags are affected.
;
; Macros using (HL) read from memory and load value into A, affecting A.
;
; Branch/call/ret destinations accept labels or addresses.
;
; Signed macros carefully handle signed overflow and sign bits.
;
; These macros only deal with 8-bit values.
;
; ============================================================================

IFNDEF MACRO8BITCONDITIONALBRANCH
DEFINE MACRO8BITCONDITIONALBRANCH

; ----------------------------------------------------------------------------
; BRANCH_IF_A_EQU val, address
; ----------------------------
; Parameters:
;   val     - 8-bit immediate value to compare with A
;   address - label or address to jump to if condition is met
;
; Description:
;   Branches to 'address' if the value in register A equals 'val'.
;
; Side effects:
;   Modifies flags due to CP instruction.
;
; Usage:
;   BRANCH_IF_A_EQU 42, Label_Equal
; ----------------------------------------------------------------------------
MACRO BRANCH_IF_A_EQU val, address
    cp val
    jp z, address
ENDM

; ----------------------------------------------------------------------------
; BRANCH_IF_A_NOT_EQU val, address
; --------------------------------
; Parameters:
;   val     - 8-bit immediate value to compare with A
;   address - label or address to jump to if condition is met
;
; Description:
;   Branches to 'address' if the value in register A is not equal to 'val'.
;
; Side effects:
;   Modifies flags due to CP instruction.
;
; Usage:
;   BRANCH_IF_A_NOT_EQU 10, Label_NotEqual
; ----------------------------------------------------------------------------
MACRO BRANCH_IF_A_NOT_EQU val, address
    cp val
    jp nz, address
ENDM

; ----------------------------------------------------------------------------
; BRANCH_HLPTR_EQU val, addr
; --------------------------
; Parameters:
;   val  - 8-bit immediate value to compare with (HL)
;   addr - label or address to jump to if condition is met
;
; Description:
;   Branches to 'addr' if the byte at memory address pointed by HL equals 'val'.
;
; Side effects:
;   Uses register A; modifies flags.
;
; Usage:
;   BRANCH_HLPTR_EQU 0xFF, Label_HLMatch
; ----------------------------------------------------------------------------
MACRO BRANCH_HLPTR_EQU val, addr
    ld a, val
    cp (hl)
    jp z, addr
ENDM

; ----------------------------------------------------------------------------
; BRANCH_HLPTR_NOT_EQU val, addr
; ------------------------------
; Parameters:
;   val  - 8-bit immediate value to compare with (HL)
;   addr - label or address to jump to if condition is met
;
; Description:
;   Branches to 'addr' if the byte at memory address pointed by HL is not equal to 'val'.
;
; Side effects:
;   Uses register A; modifies flags.
;
; Usage:
;   BRANCH_HLPTR_NOT_EQU 0x00, Label_HLNotMatch
; ----------------------------------------------------------------------------
MACRO BRANCH_HLPTR_NOT_EQU val, addr
    ld a, val
    cp (hl)
    jp nz, addr
ENDM

; ----------------------------------------------------------------------------
; BRANCH_UNSIGNED_A_LTE_V v, dest
; -------------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to jump if A <= v (unsigned)
;
; Description:
;   Branches to 'dest' if register A is less than or equal to v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_UNSIGNED_A_LTE_V 100, Label_LE_100
; ----------------------------------------------------------------------------
MACRO BRANCH_UNSIGNED_A_LTE_V v, dest
    cp v
    jp z, dest
    jp c, dest
ENDM

; ----------------------------------------------------------------------------
; BRANCH_UNSIGNED_A_LT_V v, dest
; ------------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to jump if A < v (unsigned)
;
; Description:
;   Branches to 'dest' if register A is less than v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_UNSIGNED_A_LT_V 50, Label_LT_50
; ----------------------------------------------------------------------------
MACRO BRANCH_UNSIGNED_A_LT_V v, dest
    cp v
    jp c, dest
ENDM

; ----------------------------------------------------------------------------
; BRANCH_UNSIGNED_A_GTE_V v, dest
; -------------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to jump if A >= v (unsigned)
;
; Description:
;   Branches to 'dest' if register A is greater than or equal to v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_UNSIGNED_A_GTE_V 200, Label_GTE_200
; ----------------------------------------------------------------------------
MACRO BRANCH_UNSIGNED_A_GTE_V v, dest
    cp v
    jp nc, dest
ENDM

; ----------------------------------------------------------------------------
; BRANCH_UNSIGNED_A_GT_V v, dest
; ------------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to jump if A > v (unsigned)
;
; Description:
;   Branches to 'dest' if register A is greater than v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_UNSIGNED_A_GT_V 150, Label_GT_150
; ----------------------------------------------------------------------------
MACRO BRANCH_UNSIGNED_A_GT_V v, dest
    cp v
    jr z, .end
    jp nc, dest
.end:
ENDM

; ----------------------------------------------------------------------------
; RET_UNSIGNED_A_LTE_V v
; ----------------------
; Parameters:
;   v - 8-bit unsigned immediate value
;
; Description:
;   Returns from subroutine if A <= v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   RET_UNSIGNED_A_LTE_V 42
; ----------------------------------------------------------------------------
MACRO RET_UNSIGNED_A_LTE_V v
    cp v
    ret z
    ret c
ENDM

; ----------------------------------------------------------------------------
; RET_UNSIGNED_A_LT_V v
; ---------------------
; Parameters:
;   v - 8-bit unsigned immediate value
;
; Description:
;   Returns from subroutine if A < v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   RET_UNSIGNED_A_LT_V 10
; ----------------------------------------------------------------------------
MACRO RET_UNSIGNED_A_LT_V v
    cp v
    ret c
ENDM

; ----------------------------------------------------------------------------
; RET_UNSIGNED_A_GTE_V v
; ----------------------
; Parameters:
;   v - 8-bit unsigned immediate value
;
; Description:
;   Returns from subroutine if A >= v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   RET_UNSIGNED_A_GTE_V 100
; ----------------------------------------------------------------------------
MACRO RET_UNSIGNED_A_GTE_V v
    cp v
    ret nc
ENDM

; ----------------------------------------------------------------------------
; RET_UNSIGNED_A_GT_V v
; ---------------------
; Parameters:
;   v - 8-bit unsigned immediate value
;
; Description:
;   Returns from subroutine if A > v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   RET_UNSIGNED_A_GT_V 200
; ----------------------------------------------------------------------------
MACRO RET_UNSIGNED_A_GT_V v
    cp v
    jp z, $+4
    ret nc
ENDM

; ----------------------------------------------------------------------------
; CALL_UNSIGNED_A_LTE_V v, dest
; -----------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to call if A <= v (unsigned)
;
; Description:
;   Calls subroutine at 'dest' if A <= v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   CALL_UNSIGNED_A_LTE_V 50, SomeSubroutine
; ----------------------------------------------------------------------------
MACRO CALL_UNSIGNED_A_LTE_V v, dest
    cp v
    call z, dest
    call c, dest
ENDM

; ----------------------------------------------------------------------------
; CALL_UNSIGNED_A_LT_V v, dest
; ----------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to call if A < v (unsigned)
;
; Description:
;   Calls subroutine at 'dest' if A < v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   CALL_UNSIGNED_A_LT_V 10, SomeSubroutine
; ----------------------------------------------------------------------------
MACRO CALL_UNSIGNED_A_LT_V v, dest
    cp v
    call c, dest
ENDM

; ----------------------------------------------------------------------------
; CALL_UNSIGNED_A_GTE_V v, dest
; -----------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to call if A >= v (unsigned)
;
; Description:
;   Calls subroutine at 'dest' if A >= v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   CALL_UNSIGNED_A_GTE_V 100, SomeSubroutine
; ----------------------------------------------------------------------------
MACRO CALL_UNSIGNED_A_GTE_V v, dest
    cp v
    call nc, dest
ENDM

; ----------------------------------------------------------------------------
; CALL_UNSIGNED_A_GT_V v, dest
; ----------------------------
; Parameters:
;   v    - 8-bit unsigned immediate value
;   dest - label or address to call if A > v (unsigned)
;
; Description:
;   Calls subroutine at 'dest' if A > v (unsigned comparison).
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   CALL_UNSIGNED_A_GT_V 200, SomeSubroutine
; ----------------------------------------------------------------------------
MACRO CALL_UNSIGNED_A_GT_V v, dest
    cp v
    jp z, $+6
    call nc, dest
ENDM

; ----------------------------------------------------------------------------
; BRANCH_SIGNED_A_GT_V v, dest
; ----------------------------
; Parameters:
;   v    - 8-bit signed immediate value
;   dest - label or address to jump if A > v (signed)
;
; Description:
;   Branches to 'dest' if register A is greater than v considering signed comparison.
;   This macro accounts for signed overflow and sign bits in the comparison.
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_SIGNED_A_GT_V -10, Label_SignedGT
; ----------------------------------------------------------------------------
MACRO BRANCH_SIGNED_A_GT_V v, dest
    cp v
    jp z, $+15
    jp pe, $+9
    jp p, dest
    jp $+6
    jp m, dest
ENDM

; ----------------------------------------------------------------------------
; BRANCH_SIGNED_A_GTE_V v, dest
; -----------------------------
; Parameters:
;   v    - 8-bit signed immediate value
;   dest - label or address to jump if A >= v (signed)
;
; Description:
;   Branches to 'dest' if register A is greater than or equal to v considering signed comparison.
;   Handles overflow and sign bits.
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_SIGNED_A_GTE_V -5, Label_SignedGTE
; ----------------------------------------------------------------------------
MACRO BRANCH_SIGNED_A_GTE_V v, dest
    cp v
    jp pe, $+9
    jp p, dest
    jr .end
    jp m, dest
.end:
ENDM

; ----------------------------------------------------------------------------
; BRANCH_SIGNED_A_LT_V v, dest
; ----------------------------
; Parameters:
;   v    - 8-bit signed immediate value
;   dest - label or address to jump if A < v (signed)
;
; Description:
;   Branches to 'dest' if register A is less than v considering signed comparison.
;   Handles overflow and sign bits.
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_SIGNED_A_LT_V 10, Label_SignedLT
; ----------------------------------------------------------------------------
MACRO BRANCH_SIGNED_A_LT_V v, dest
    cp v
    jp pe, $+9
    jp m, dest
    jp $+6
    jp p, dest
ENDM

; ----------------------------------------------------------------------------
; BRANCH_SIGNED_A_LTE_V v, dest
; -----------------------------
; Parameters:
;   v    - 8-bit signed immediate value
;   dest - label or address to jump if A <= v (signed)
;
; Description:
;   Branches to 'dest' if register A is less than or equal to v considering signed comparison.
;   Handles overflow and sign bits.
;
; Side effects:
;   Modifies flags.
;
; Usage:
;   BRANCH_SIGNED_A_LTE_V 0, Label_SignedLTE
; ----------------------------------------------------------------------------
MACRO BRANCH_SIGNED_A_LTE_V v, dest
    cp v
    jp z, dest
    jp pe, $+9
    jp m, dest
    jr. end
    jp p, dest
.end:
ENDM

ENDIF
