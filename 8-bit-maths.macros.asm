
  **
  ; ============================================================================
  ; Z80 8-bit Arithmetic Macros for SJASMPlus
  ; Author: Jack Stinchcombe
  ; License: MIT
  ;
  ; Description:
  ;   A collection of assembly macros for Z80 8-bit arithmetic operations using
  ;   SJASMPlus syntax. These macros simplify common patterns for manipulating
  ;   8-bit values in registers and memory.
  ;
  ; Usage:
  ;   Include this file in your SJASMPlus project using:
  ;     INCLUDE "8-bit-maths-macros.inc"
  ; ============================================================================

  IFNDEF MACRO8BITMATHS
  DEFINE MACRO8BITMATHS

  ; ----------------------------------------------------------------------------
  ; MIN_UNSIGNED_A_VAL val
  ; If A < val, sets A = val
  ; ----------------------------------------------------------------------------
  MACRO MIN_UNSIGNED_A_VAL val
      cp val
      jr c, .end
      ld a, val
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; MAX_UNSIGNED_A_VAL val
  ; If A > val, sets A = val
  ; ----------------------------------------------------------------------------
  MACRO MAX_UNSIGNED_A_VAL val ; A = max (A, val)
      cp val
      jr nc, .end
      ld a, val
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_ADDR_REG addr, reg
  ; Add a register (other than A) or value to memory address  (addr) += reg
  ; ----------------------------------------------------------------------------
  MACRO ADD_ADDR_REG addr, reg
      ld a, (addr)
      add reg
      ld (addr), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_ADDR_ADDR addr1, addr2
  ; Adds contents of addr2 to addr1:  (addr1) += (addr2)
  ; ----------------------------------------------------------------------------
  MACRO ADD_ADDR_ADDR addr1, addr2
      push hl
      ld hl, addr2
      ld a, (addr1)
      add (hl)
      ld (addr1), a
      pop hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_IX idx1, idx2
  ; Adds (ix+idx2) to (ix+idx1):  (ix+idx1) += (ix+idx2)
  ; ----------------------------------------------------------------------------
  MACRO ADD_IX idx1, idx2
      ld a, (ix + idx1)
      add (ix + idx2)
      ld (ix + idx1), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; SUM_IX idx1, idx2, idx3
  ; Computes (ix+idx1) = (ix+idx2) + (ix+idx3)
  ; ----------------------------------------------------------------------------
  MACRO SUM_IX idx1, idx2, idx3
      ld a, (ix + idx2)
      add (ix + idx3)
      ld (ix + idx1), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG8_IXPLUS n
  ; Negates (ix+n):  (ix+n) = - (ix+n) — Uses up A and F
  ; ----------------------------------------------------------------------------
  MACRO NEG8_IXPLUS n
      xor a
      sub (ix + n)
      ld (ix + n), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS8_IXPLUS n
  ; Takes absolute value of (ix+n) if signed: (ix+n) = abs(ix+n)
  ; ----------------------------------------------------------------------------
  MACRO ABS8_IXPLUS n
      ld a, (ix + n)
      and 128           ; Faster than bit 7,a
      jr z, .end
      neg
      ld (ix + n), a
  .end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS8_A
  ; Takes absolute value of register A if A register is a signed value
  ; ----------------------------------------------------------------------------
  MACRO ABS8_A
      bit 7, a
      jr z, .end
      neg
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS8_HLPTR
  ; Takes absolute value of value at (hl):  (hl) = abs((hl))
  ; Uses up A
  ; ----------------------------------------------------------------------------
  MACRO ABS8_HLPTR
      bit 7, (hl)
      jr nz, .end
      ld a, (hl)
      neg
      ld (hl), a
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS8_DEPTR
  ; Takes absolute value of value at (de):  (de) = abs((de))
  ; Uses up A, swaps HL/DE temporarily
  ; ----------------------------------------------------------------------------
  MACRO ABS8_DEPTR
      ex de, hl
      bit 7, (hl)
      jr nz, .end
      ld a, (hl)
      neg
      ld (hl), a
      ex de, hl
.end:
  ENDM

  ENDIF
