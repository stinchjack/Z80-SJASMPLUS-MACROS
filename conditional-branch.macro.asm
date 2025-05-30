  ; ============================================================================
  ; Z80 Conditional Branch/Call/Return Macros (Flag-Based) for SJASMPlus
  ; Author: Jack Stinchcombe
  ; License: MIT
  ;
  ; Description:
  ;   A collection of flag-based branching, calling, and returning macros for
  ;   conditional flow control on 8-bit values using SJASMPlus syntax.
  ;   These macros rely on flags set by prior instructions (e.g., CP, SUB, another macro).
  ;
  ;
  ; Key Points:
  ; - These macros depend on flags from previous comparisons (e.g., CP, SUB, another macro).
  ; - No immediate comparison is done inside these macros.
  ; - Branching macros assume A was already compared via CP.
  ; - Signed macros handle overflow and sign using PE/M/P flag logic.
  ; - These macros are designed to be included *after* a comparison has occurred.
  ; - All destinations are absolute jumps /calls.
  ;
  ; ============================================================================

  IFNDEF MACROCONDITIONALBRANCH
  DEFINE MACROCONDITIONALBRANCH

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_LTE dest
  ; ------------------------
  ; Parameters:
  ;   dest - label or address
  ;
  ; Description:
  ;   Jumps to dest if the previous comparison resulted in flags indicating
  ;   less-than-or-equal-to (<=) condition for two unsigned values.
  ;
  ; Usage:
  ;   BRANCH_UNSIGNED_LTE SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_LTE dest
      jp z, dest
      jp c, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_LT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ; Jumps to dest if flags indicate less-than (<) condition for two unsigned values.
  ; Usage:
  ;   BRANCH_UNSIGNED_LT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_LT dest
      jp c, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_GTE dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Jumps to dest if flags indicate greater-than-or-equal (>=) condition for two unsigned values.
  ;
  ; Usage:
  ;   BRANCH_UNSIGNED_GTE SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_GTE dest
      jp nc, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_UNSIGNED_GT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Jumps to dest if flags indicate greater (>) condition for two unsigned values.
  ;
  ; Usage:
  ;   BRANCH_UNSIGNED_GT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_UNSIGNED_GT dest
      jr z, .end
      jp nc, dest
.end:
  ENDM



  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_LT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Jumps to dest if flags indicate less-than (<) condition for two signed values.
  ;
  ; Usage:
  ;   BRANCH_SIGNED_LT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_LT dest
      jp pe, .jpp
      jp m, dest
      jr .end
.jpp:
      jp p, dest
.end:
  ENDM


  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_LTE dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Jumps to dest flags indicate less-than-or-equal (<=) condition for two signed values.
  ;
  ; Usage:
  ;   BRANCH_SIGNED_LT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_LTE dest
      jp z, dest
      MACRO BRANCH_SIGNED_LT dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_GTE dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Jumps to dest flags indicate greater-than-or-equal (>=) condition for two signed values.
  ;
  ; Usage:
  ;   BRANCH_SIGNED_GTE SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_GTE dest
      jp pe, .jpm
      jp p, dest
      jr .end
.jpm:
      jp m, dest
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; BRANCH_SIGNED_GT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Jumps to dest if flags indicate greater-than (>) condition for
  ;   two unsigned values.
  ;
  ; Usage:
  ;   BRANCH_SIGNED_GT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO BRANCH_SIGNED_GT dest
      jr z, .end
      BRANCH_SIGNED_GTE dest
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_LTE dest
  ; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Calls dest if flags indicate less-than-or-equal-to (<=) condition for two
  ;   unsigned values.
  ;
  ; Usage:
  ;   CALL_UNSIGNED_LTE SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_LTE dest
      jr c, .callc
      call z, dest
      jr .end
.callc:
      call c, dest
.end:
  ENDM


  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_LT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Calls dest if flags indicate less-than (<) condition for two unsigned values.
  ;
  ; Usage:
  ;   CALL_UNSIGNED_LT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_LT dest
      call c, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_GTE dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Calls dest if flags indicate greater-than-or-equal (>=) condition for
  ;   two unsigned values.
  ;
  ; Usage:
  ;   CALL_UNSIGNED_GTE SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_GTE dest
      call nc, dest
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_UNSIGNED_GT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Calls dest if flags indicate greater (>) condition for two unsigned values.
  ;
  ; Usage:
  ;   CALL_UNSIGNED_GT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_UNSIGNED_GT dest
      jr z, .end
      call nc, dest
.end:
  ENDM


  ; ----------------------------------------------------------------------------
  ; CALL_SIGNED_GTE dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;  Calls dest flags indicate greater-than-or-equal (>=) condition
  ;   for two signed values.
  ;
  ; Usage:
  ;   CALL_SIGNED_GTE SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_SIGNED_GTE dest
      jp pe, .callm
      call p, dest
      jr .end
.callm
      call m, dest
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_SIGNED_GT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Calls dest if flags indicate greater-than (>) condition for two signed values.
  ;
  ; Usage:
  ;   CALL_SIGNED_GT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_SIGNED_GT dest
      jr z, .end
      CALL_SIGNED_GTE dest
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_SIGNED_LT dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Calls dest if flags indicate less-than (<) condition for two signed values.
  ;
  ; Usage:
  ;   CALL_SIGNED_LT SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_SIGNED_LT dest
      jp pe, .callp
      call m, dest
      jr .end
  .callp:
      call p, dest
  .end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; CALL_SIGNED_LTE dest
	; ------------------------
	; Parameters:
	;   dest - label or address
	;
	; Description:
  ;   Calls dest flags indicate less-than-or-equal (<=) condition for two signed values.
  ;
  ; Usage:
  ;   CALL_SIGNED_LTE SomeLabel
  ; ----------------------------------------------------------------------------
  MACRO CALL_SIGNED_LTE dest
      jr nz, .callsignedLT
      call dest
      jr .end
.callsignedLT:
      CALL_SIGNED_LT
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_LTE
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns if flags indicating less-than-or-equal-to (<=) condition for
  ;   two unsigned values.
  ;
  ; Usage:
  ;   RET_UNSIGNED_LTE
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_LTE
      ret z
      ret c
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_LT
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns if flags indicate less-than (<) condition for two unsigned values.
  ;
  ; Usage:
  ;   RET_UNSIGNED_LT
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_LT
      ret c
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_GTE
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns if flags indicate greater-than-or-equal (>=) condition for two unsigned values.
  ;
  ; Usage:
  ;   RET_UNSIGNED_GTE
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_GTE
      ret nc
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_UNSIGNED_GT
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns if flags indicate greater (>) condition for two unsigned values.
  ;
  ; Usage:
  ;   RET_UNSIGNED_GT
  ; ----------------------------------------------------------------------------
  MACRO RET_UNSIGNED_GT
      jp z, .end
      ret nc
.end:
  ENDM


  ; ----------------------------------------------------------------------------
  ; RET_SIGNED_GTE
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns flags indicate greater-than-or-equal (>=) condition for two signed values.
  ;
  ; Usage:
  ;   RET_SIGNED_GTE
  ; ----------------------------------------------------------------------------
  MACRO RET_SIGNED_GTE
      jp pe, .retm
      ret p
      jr .end
  .retm:
      ret m
  .end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_SIGNED_GT
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns if flags indicate greater-than (>) condition for
  ;   two signed values.
  ;
  ; Usage:
  ;   RET_SIGNED_GT
  ; ----------------------------------------------------------------------------
  MACRO RET_SIGNED_GT
      jr z, .end
      RET_SIGNED_GTE
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_SIGNED_LT
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns if flags indicate less-than (<) condition for two signed values.
  ;
  ; Usage:
  ;   RET_SIGNED_LT
  ; ----------------------------------------------------------------------------
  MACRO RET_SIGNED_LT
      jp pe, .retp
      ret m
      jr .end
  .retp:
      ret p
  .end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; RET_SIGNED_LTE
	; ------------------------
	; Parameters:
	;   (none)
	;
	; Description:
  ;   Returns if flags indicate less-than-or-equal-to (<=) condition for
  ;   two signed values.
  ;
  ; Usage:
  ;   RET_SIGNED_LTE
  ; ----------------------------------------------------------------------------
  MACRO RET_SIGNED_LTE
      ret z
      RET_SIGNED_LT
  ENDM

  ENDIF
