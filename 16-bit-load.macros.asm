  ; ============================================================================
  ; Z80 16-bit Load Macros for SJASMPlus
  ; Author: Jack Stinchcombe
  ; License: MIT
  ;
  ; Description:
  ;   A collection of assembly macros for Z80 16-bit load operations using
  ;   SJASMPlus syntax. These macros provide convenient ways to load 16-bit
  ;   values into register pairs and perform pointer operations.
  ;
  ; Key Points:
  ; These macros work with 16-bit register pairs (HL, BC, DE, IX, IY, SP)
  ;
  ; Some macros modify register A and flags
  ;
  ; Signed extension macros handle 8-bit to 16-bit conversion
  ;
  ; Offset macros assume 8-bit unsigned offsets (0..255) unless noted
  ;
  ; Some macros use temporary registers and stack operations
  ; ============================================================================

  IFNDEF MACRO16BITLD
  DEFINE MACRO16BITLD

  ; ----------------------------------------------------------------------------
  ; LD_HL_SIGNED_A
  ; --------------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Sign-extends register A into HL register pair.
  ;   If A is negative (bit 7 set), H becomes 0xFF, otherwise 0x00.
  ;
  ; Side effects:
  ;   Modifies register A and flags (AF register pair).
  ;
  ; Z80 Equivalent:
  ;   ld hl, a (with sign extension)
  ;
  ; Usage:
  ;   LD_HL_SIGNED_A
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_SIGNED_A
      ld l, a
      rlca                    ; move sign bit to carry flag, Cf set = negative
      sbc a, a                ; A = 0xFF if input A was <0 and 0x00 if A was>=0
      ld h, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_SIGNED_A
  ; --------------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Sign-extends register A into BC register pair.
  ;   If A is negative (bit 7 set), B becomes 0xFF, otherwise 0x00.
  ;
  ; Side effects:
  ;   Modifies register A and flags (AF register pair).
  ;
  ; Z80 Equivalent:
  ;   ld bc, a (with sign extension)
  ;
  ; Usage:
  ;   LD_BC_SIGNED_A
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_SIGNED_A
      ld c, a
      rlca                    ; move sign bit to carry flag, Cf set = negative
      sbc a, a                ; A = 0xFF if input A was <0 and 0x00 if A was>=0
      ld b, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; EX_BC_HL
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Exchanges the contents of BC and HL register pairs.
  ;
  ; Side effects:
  ;   Uses stack temporarily.
  ;
  ; Z80 Equivalent:
  ;   ex bc, hl
  ;
  ; Usage:
  ;   EX_BC_HL
  ; ----------------------------------------------------------------------------
  MACRO EX_BC_HL
      push hl
      ld hl, bc
      pop bc
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_UNSIGNED_A
  ; ----------------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Zero-extends register A into HL register pair.
  ;   H is set to 0x00, L is set to A.
  ;
  ; Side effects:
  ;   Modifies H register.
  ;
  ; Z80 Equivalent:
  ;   ld hl, a (with zero extension)
  ;
  ; Usage:
  ;   LD_HL_UNSIGNED_A
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_UNSIGNED_A
      ld h, 0
      ld l, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_A
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Alias for LD_HL_UNSIGNED_A. Zero-extends A into HL.
  ;
  ; Side effects:
  ;   Modifies H register.
  ;
  ; Z80 Equivalent:
  ;   ld hl, a
  ;
  ; Usage:
  ;   LD_HL_A
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_A
      LD_HL_UNSIGNED_A
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_UNSIGNED_A
  ; ----------------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Zero-extends register A into BC register pair.
  ;   B is set to 0x00, C is set to A.
  ;
  ; Side effects:
  ;   Modifies B register.
  ;
  ; Z80 Equivalent:
  ;   ld bc, a (with zero extension)
  ;
  ; Usage:
  ;   LD_BC_UNSIGNED_A
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_UNSIGNED_A
      ld b, 0
      ld c, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_A
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Alias for LD_BC_UNSIGNED_A. Zero-extends A into BC.
  ;
  ; Side effects:
  ;   Modifies B register.
  ;
  ; Z80 Equivalent:
  ;   ld bc, a
  ;
  ; Usage:
  ;   LD_BC_A
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_A
      LD_BC_UNSIGNED_A
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_IX_SP
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the current stack pointer value into IX register.
  ;
  ; Side effects:
  ;   Modifies flags.
  ;
  ; Z80 Equivalent:
  ;   ld ix, sp
  ;
  ; Usage:
  ;   LD_IX_SP
  ; ----------------------------------------------------------------------------
  MACRO LD_IX_SP
      ld ix, 0
      add ix, sp
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_IY_SP
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the current stack pointer value into IY register.
  ;
  ; Side effects:
  ;   Modifies flags.
  ;
  ; Z80 Equivalent:
  ;   ld iy, sp
  ;
  ; Usage:
  ;   LD_IY_SP
  ; ----------------------------------------------------------------------------
  MACRO LD_IY_SP
      ld iy, 0
      add iy, sp
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_HLPTR_FASTER
  ; ------------------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the 16-bit value pointed to by HL into HL register pair.
  ;   Faster version that uses register A.
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld hl, (hl)
  ;
  ; Usage:
  ;   LD_HL_HLPTR_FASTER
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_HLPTR_FASTER
      ld a, (hl)
      inc hl
      ld h, (hl)
      ld l, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_HLPTR_SLOW
  ; -----------------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the 16-bit value pointed to by HL into HL register pair.
  ;   Slower version that preserves register A.
  ;
  ; Side effects:
  ;   Uses DE register temporarily.
  ;
  ; Z80 Equivalent:
  ;   ld hl, (hl)
  ;
  ; Usage:
  ;   LD_HL_HLPTR_SLOW
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_HLPTR_SLOW
      push de
      ; DE = HL
      ld d, h
      ld e, l
      ; ld hl, (de)
      ex de, hl
      ld e, (hl)
      inc hl
      ld d, (hl)
      ex de, hl
      pop de
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_SP
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the current stack pointer value into HL register pair.
  ;
  ; Side effects:
  ;   Uses AF register temporarily.
  ;
  ; Z80 Equivalent:
  ;   ld hl, sp
  ;
  ; Usage:
  ;   LD_HL_SP
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_SP
      push af
      ld hl, 0
      add hl, sp
      pop af
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_DE_HLPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the 16-bit value pointed to by HL into DE register pair.
  ;   HL is restored to original value.
  ;
  ; Side effects:
  ;   Temporarily modifies HL.
  ;
  ; Z80 Equivalent:
  ;   ld de, (hl)
  ;
  ; Usage:
  ;   LD_DE_HLPTR
  ; ----------------------------------------------------------------------------
  MACRO LD_DE_HLPTR
      ld e, (hl)
      inc hl
      ld d, (hl)
      dec hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_HLPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the 16-bit value pointed to by HL into BC register pair.
  ;   HL is restored to original value.
  ;
  ; Side effects:
  ;   Temporarily modifies HL.
  ;
  ; Z80 Equivalent:
  ;   ld bc, (hl)
  ;
  ; Usage:
  ;   LD_BC_HLPTR
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_HLPTR
      ld c, (hl)
      inc hl
      ld b, (hl)
      dec hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_DEPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the 16-bit value pointed to by DE into HL register pair.
  ;   DE is restored to original value.
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL.
  ;
  ; Z80 Equivalent:
  ;   ld hl, (de)
  ;
  ; Usage:
  ;   LD_HL_DEPTR
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_DEPTR
      ex de, hl
      ld e, (hl)
      inc hl
      ld d, (hl)
      dec hl
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_DEPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the 16-bit value pointed to by DE into BC register pair.
  ;   DE is restored to original value.
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL.
  ;
  ; Z80 Equivalent:
  ;   ld bc, (de)
  ;
  ; Usage:
  ;   LD_BC_DEPTR
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_DEPTR
      ex de, hl
      ld c, (hl)
      inc hl
      ld b, (hl)
      dec hl
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_IX_HLPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads HL + n into IX register pair.
  ;   IX = HL + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld ix, hl : add ix, n
  ;
  ; Usage:
  ;   LD_IX_HLPLUS 10
  ; ----------------------------------------------------------------------------
  MACRO LD_IX_HLPLUS n
      ld a, n
      add l
      ld ixl, a
      adc h
      sub ixl
      ld ixh, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_IXPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads IX + n into BC register pair.
  ;   BC = IX + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld bc, ix : add bc, n
  ;
  ; Usage:
  ;   LD_BC_IXPLUS 5
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_IXPLUS n
      ld a, n
      add ixl
      ld c, a
      adc ixh
      sub c
      ld b, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_IY_IXPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads IX + n into IY register pair.
  ;   IY = IX + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld iy, ix : add iy, n
  ;
  ; Usage:
  ;   LD_IY_IXPLUS 8
  ; ----------------------------------------------------------------------------
  MACRO LD_IY_IXPLUS n
      ld a, n
      add ixl
      ld iyl, a
      adc ixh
      sub iyl
      ld iyh, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_IXPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads IX + n into HL register pair.
  ;   HL = IX + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld hl, ix : add hl, n
  ;
  ; Usage:
  ;   LD_HL_IXPLUS 12
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_IXPLUS n
      ld a, n
      add ixl
      ld l, a
      adc ixh
      sub l
      ld h, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_IYPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads IY + n into HL register pair.
  ;   HL = IY + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld hl, iy : add hl, n
  ;
  ; Usage:
  ;   LD_HL_IYPLUS 15
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_IYPLUS n
      ld a, n
      add iyl
      ld l, a
      adc iyh
      sub l
      ld h, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_DE_IXPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads IX + n into DE register pair.
  ;   DE = IX + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld de, ix : add de, n
  ;
  ; Usage:
  ;   LD_DE_IXPLUS 20
  ; ----------------------------------------------------------------------------
  MACRO LD_DE_IXPLUS n
      ld a, n
      add ixl
      ld e, a
      adc ixh
      sub e
      ld d, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_DE_IYPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads IY + n into DE register pair.
  ;   DE = IY + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld de, iy : add de, n
  ;
  ; Usage:
  ;   LD_DE_IYPLUS 7
  ; ----------------------------------------------------------------------------
  MACRO LD_DE_IYPLUS n
      ld a, n
      add iyl
      ld e, a
      adc iyh
      sub e
      ld d, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_DE_HLPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads HL + n into DE register pair.
  ;   DE = HL + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld de, hl : add de, n
  ;
  ; Usage:
  ;   LD_DE_HLPLUS 3
  ; ----------------------------------------------------------------------------
  MACRO LD_DE_HLPLUS n
      ld a, n
      add l
      ld e, a
      adc h
      sub e
      ld d, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_DE_BC_16PLUS val
  ; -------------------
  ; Parameters:
  ;   val - 16-bit unsigned offset
  ;
  ; Description:
  ;   Loads BC + val into DE register pair.
  ;   DE = BC + val
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld de, bc : add de, val
  ;
  ; Usage:
  ;   LD_DE_BC_16PLUS 1000
  ; ----------------------------------------------------------------------------
  MACRO LD_DE_BC_16PLUS val
      ld a, lo(val)
      add c
      ld e, a
      ld a, hi(val)
      adc b
      ld d, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_IYPLUS n
  ; --------------
  ; Parameters:
  ;   n - 8-bit unsigned offset
  ;
  ; Description:
  ;   Loads IY + n into BC register pair.
  ;   BC = IY + n
  ;
  ; Side effects:
  ;   Modifies register A.
  ;
  ; Z80 Equivalent:
  ;   ld bc, iy : add bc, n
  ;
  ; Usage:
  ;   LD_BC_IYPLUS 25
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_IYPLUS n
      ld a, n
      add iyl
      ld c, a
      adc iyh
      sub c
      ld b, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_HL_SPPLUS val
  ; ----------------
  ; Parameters:
  ;   val - signed or unsigned 16-bit value
  ;
  ; Description:
  ;   Loads SP + val into HL register pair.
  ;   HL = SP + val
  ;
  ; Side effects:
  ;   Modifies flags.
  ;
  ; Z80 Equivalent:
  ;   ld hl, val : add hl, sp
  ;
  ; Usage:
  ;   LD_HL_SPPLUS -10
  ; ----------------------------------------------------------------------------
  MACRO LD_HL_SPPLUS val
      ld hl, val
      add hl, sp
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_DE_SPPLUS val
  ; ----------------
  ; Parameters:
  ;   val - signed or unsigned 16-bit value
  ;
  ; Description:
  ;   Loads SP + val into DE register pair.
  ;   DE = SP + val
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL.
  ;
  ; Z80 Equivalent:
  ;   ld de, val : add de, sp
  ;
  ; Usage:
  ;   LD_DE_SPPLUS 100
  ; ----------------------------------------------------------------------------
  MACRO LD_DE_SPPLUS val
      ex de, hl
      ld hl, val
      add hl, sp
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_BC_SPPLUS val
  ; ----------------
  ; Parameters:
  ;   val - signed or unsigned 16-bit value
  ;
  ; Description:
  ;   Loads SP + val into BC register pair.
  ;   BC = SP + val
  ;
  ; Side effects:
  ;   Uses HL register temporarily and stack.
  ;
  ; Z80 Equivalent:
  ;   ld bc, val : add bc, sp
  ;
  ; Usage:
  ;   LD_BC_SPPLUS 50
  ; ----------------------------------------------------------------------------
  MACRO LD_BC_SPPLUS val
      push hl
      ld hl, val
      add hl, sp
      ld b, h
      ld c, l
      pop hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; LD_IX_NEG_A
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Loads the negated value of register A into IX register pair.
  ;   IX = -A (where A is treated as unsigned)
  ;
  ; Side effects:
  ;   Modifies register A and flags.
  ;
  ; Z80 Equivalent:
  ;   ld ix, a : neg ix
  ;
  ; Usage:
  ;   LD_IX_NEG_A
  ; ----------------------------------------------------------------------------
  MACRO LD_IX_NEG_A
      ld ixh, 0
      ld ixl, a
      xor a
      sub ixl
      ld ixl, a
      sbc a, a
      sub ixh
      ld ixh, a
  ENDM

  ENDIF
