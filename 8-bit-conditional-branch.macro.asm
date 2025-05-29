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
  ;   Include this file in your SJASMPlus project using:
  ;     INCLUDE "8-bit-conditional-branch.macro.asm"
  ; ============================================================================

  IFNDEF MACRO8BITCONDITIONALBRANCH
  DEFINE MACRO8BITCONDITIONALBRANCH

  ; ----------------------------------------------------------------------------
  ; BRANCH_IF_A_EQU val, address
  ; Branches to 'address' if A == val
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_IF_A_EQU val, address
      cp val
      jp z, address
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_IF_A_NOT_EQU val, address
  ; Branches to 'address' if A != val
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_IF_A_NOT_EQU val, address
      cp val
      jp nz, address
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_HLPTR_EQU val, addr
  ; Branches to 'addr' if (HL) == val
  ; Uses up A register
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_HLPTR_EQU val, addr
      ld a, val
      cp (hl)
      jp z, addr
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_HLPTR_NOT_EQU val, addr
  ; Branches to 'addr' if (HL) != val
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_HLPTR_NOT_EQU val, addr
      ld a, val
      cp (hl)
      jp nz, addr
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_A_LTE_V v, dest
  ; Branches to 'dest' if A <= v (unsigned comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_A_LTE_V v, dest
      cp v
      jp z, dest
      jp c, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_A_LT_V v, dest
  ; Branches to 'dest' if A < v (unsigned comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_A_LT_V v, dest
      cp v
      jp c, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_A_GTE_V v, dest
  ; Branches to 'dest' if A >= v (unsigned comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_A_GTE_V v, dest
      cp v
      jp nc, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_A_GT_V v, dest
  ; Branches to 'dest' if A > v (unsigned comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_A_GT_V v, dest
      cp v
      jr z, .end       ; Skip if equal
      jp nc, dest
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_A_LTE_V v
  ; Returns if A <= v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_A_LTE_V v
      cp v
      ret z
      ret c
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_A_LT_V v
  ; Returns if A < v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_A_LT_V v
      cp v
      ret c
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_A_GTE_V v
  ; Returns if A >= v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_A_GTE_V v
      cp v
      ret nc
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_A_GT_V v
  ; Returns if A > v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_A_GT_V v
      cp v
      jp z, $+4        ; Skip ret nc if equal
      ret nc
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_A_LTE_V v, dest
  ; Calls 'dest' if A <= v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_A_LTE_V v, dest
      cp v
      call z, dest
      call c, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_A_LT_V v, dest
  ; Calls 'dest' if A < v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_A_LT_V v, dest
      cp v
      call c, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_A_GTE_V v, dest
  ; Calls 'dest' if A >= v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_A_GTE_V v, dest
      cp v
      call nc, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_A_GT_V v, dest
  ; Calls 'dest' if A > v (unsigned)
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_A_GT_V v, dest
      cp v
      jp z, $+6        ; Skip call if equal
      call nc, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_A_GT_V v, dest
  ; Branches to 'dest' if A > v (signed comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_A_GT_V v, dest
      cp v
      jp z, $+15       ; Skip rest if equal
      jp pe, $+9       ; Overflow → ambiguous; jump to check negative
      jp p, dest
      jp $+6           ; Skip next jump
      jp m, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_A_GTE_V v, dest
  ; Branches to 'dest' if A >= v (signed comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_A_GTE_V v, dest
      cp v
      jp pe, $+9       ; Overflow → ambiguous; jump to check sign
      jp p, dest
      jr .end
      jp m, dest
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_A_LT_V v, dest
  ; Branches to 'dest' if A < v (signed comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_A_LT_V v, dest
      cp v
      jp pe, $+9       ; Overflow → ambiguous; jump to check sign
      jp m, dest
      jp $+6           ; Skip next
      jp p, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_A_LTE_V v, dest
  ; Branches to 'dest' if A <= v (signed comparison)
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_A_LTE_V v, dest
      cp v
      jp z, dest
      jp pe, $+9       ; Overflow → ambiguous
      jp m, dest
      jr. end
      jp p, dest
.end:
  ENDM

  ENDIF
