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
  ;
  ; Key Points:
  ; These macros work only on 8-bit values
  ;
  ; Some macros modify register A and flags
  ;
  ; Macros using IX offsets assume signed offsets (-128..127)
  ;
  ; ADD_ADDR_REG does NOT accept A as reg parameter
  ; ============================================================================

  IFNDEF MACRO8BITMATHS
  DEFINE MACRO8BITMATHS

  ; ----------------------------------------------------------------------------
  ; MIN_UNSIGNED_A_VAL val
  ; ----------------------
  ; Parameters:
  ;   val - immediate 8-bit unsigned constant
  ;
  ; Description:
  ;   Clamp register A to a minimum value (A = max(A, val)).
  ;   If A < val, then A is set to val.
  ;
  ; Side effects:
  ;   Modifies register A and flags (AF register pair).
  ;
  ; Usage:
  ;   MIN_UNSIGNED_A_VAL 42
  ; ----------------------------------------------------------------------------
  MACRO MIN_UNSIGNED_A_VAL val
      cp val
      jr c, .end
      ld a, val
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; MAX_UNSIGNED_A_VAL val
  ; ----------------------
  ; Parameters:
  ;   val - immediate 8-bit unsigned constant
  ;
  ; Description:
  ;   Clamp register A to a maximum value (A = min(A, val)).
  ;   If A > val, then A is set to val.
  ;
  ; Side effects:
  ;   Modifies register A and flags (AF register pair).
  ;
  ;
  ; Usage:
  ;   MAX_UNSIGNED_A_VAL 200
  ; ----------------------------------------------------------------------------
  MACRO MAX_UNSIGNED_A_VAL val
      cp val
      jr nc, .end
      ld a, val
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_ADDR_REG addr, reg
  ; ----------------------
  ; Parameters:
  ;   addr - memory address (label or direct)
  ;   reg  - 8-bit register (not A)
  ;
  ; Description:
  ;   Adds the value of register 'reg' to the byte at memory location 'addr'.
  ;   (addr) += reg. Does NOT work with A register
  ;
  ; Side effects:
  ;   Modifies register A and flags.
  ;
  ; Z80 Equivalent:
  ;   add (addr), r
  ;
  ; Usage:
  ;   ADD_ADDR_REG myVar, b
  ; ----------------------------------------------------------------------------
  MACRO ADD_ADDR_REG addr, reg
      ld a, (addr)
      add reg
      ld (addr), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_ADDR_ADDR addr1, addr2
  ; --------------------------
  ; Parameters:
  ;   addr1 - destination memory address
  ;   addr2 - source memory address
  ;
  ; Description:
  ;   Adds the byte at addr2 to the byte at addr1 and stores the result in addr1.
  ;   (addr1) += (addr2)
  ;
  ; Side effects:
  ;   Uses register A and HL; pushes and pops HL.
  ;
  ; Z80 Equivalent:
  ;   add (addr1), (addr2)
  ;
  ; Usage:
  ;   ADD_ADDR_ADDR var1, var2
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
  ; -----------------
  ; Parameters:
  ;   idx1 - IX offset destination (signed 8-bit)
  ;   idx2 - IX offset source (signed 8-bit)
  ;
  ; Description:
  ;   Adds the value at (IX + idx2) to the value at (IX + idx1).
  ;   (IX+idx1) += (IX+idx2)
  ;
  ; Side effects:
  ;   Modifies register A and flags.
  ;
  ; Z80 Equivalent:
  ;   add (ix+idx1), (ix+idx2)
  ;
  ; Usage:
  ;   ADD_IX 0, 1
  ; ----------------------------------------------------------------------------
  MACRO ADD_IX idx1, idx2
      ld a, (ix + idx1)
      add (ix + idx2)
      ld (ix + idx1), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; SUM_IX idx1, idx2, idx3
  ; -----------------------
  ; Parameters:
  ;   idx1 - IX offset destination (signed 8-bit)
  ;   idx2 - IX offset source 1 (signed 8-bit)
  ;   idx3 - IX offset source 2 (signed 8-bit)
  ;
  ; Description:
  ;   Computes the sum of bytes at (IX+idx2) and (IX+idx3) and stores it in (IX+idx1).
  ;   (IX+idx1) = (IX+idx2) + (IX+idx3)
  ;
  ; Side effects:
  ;   Modifies register A and flags.
  ;
  ; Z80 Equivalent:
  ;   ld (ix+idx1), (ix+idx2)
  ;   add (ix+idx3)
  ;
  ; Usage:
  ;   SUM_IX 0, 1, 2
  ; ----------------------------------------------------------------------------
  MACRO SUM_IX idx1, idx2, idx3
      ld a, (ix + idx2)
      add (ix + idx3)
      ld (ix + idx1), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG8_IXPLUS n
  ; -------------
  ; Parameters:
  ;   n - signed 8-bit IX offset
  ;
  ; Description:
  ;   Negates the value at (IX + n).
  ;   (IX+n) = - (IX+n)
  ;
  ; Side effects:
  ;   Uses registers A and flags.
  ;
  ;
  ; Usage:
  ;   NEG8_IXPLUS -3
  ; ----------------------------------------------------------------------------
  MACRO NEG8_IXPLUS n
      xor a
      sub (ix + n)
      ld (ix + n), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS8_IXPLUS n
  ; -------------
  ; Parameters:
  ;   n - signed 8-bit IX offset
  ;
  ; Description:
  ;   Replaces the value at (IX+n) with its absolute value (treating it as signed).
  ;   (IX+n) = abs((IX+n))
  ;
  ; Side effects:
  ;   Uses registers A and flags.
  ;
  ;
  ; Usage:
  ;   ABS8_IXPLUS 5
  ; ----------------------------------------------------------------------------
  MACRO ABS8_IXPLUS n
      ld a, (ix + n)
      and 128
      jr z, .end
      neg
      ld (ix + n), a
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS8_A
  ; -------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts register A to its absolute value (if signed).
  ;
  ; Side effects:
  ;   Modifies register A and flags.
  ;
  ;
  ; Usage:
  ;   ABS8_A
  ; ----------------------------------------------------------------------------
  MACRO ABS8_A
      bit 7, a
      jr z, .end
      neg
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS8_HLPTR
  ; ----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts the byte pointed to by HL to its absolute value (if signed).
  ;   (HL) = abs((HL))
  ;
  ; Side effects:
  ;   Uses register A and flags.
  ;
  ;
  ; Usage:
  ;   ABS8_HLPTR
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
  ; ----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts the byte pointed to by DE to its absolute value (if signed).
  ;   (DE) = abs((DE))
  ;
  ; Side effects:
  ;   Uses registers A and HL; swaps HL and DE temporarily.
  ;   Uses flags.
  ;
  ; Usage:
  ;   ABS8_DEPTR
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
