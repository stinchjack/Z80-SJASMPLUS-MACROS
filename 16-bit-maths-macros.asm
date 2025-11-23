  ; ============================================================================
  ; Z80 16-bit Arithmetic Macros for SJASMPlus
  ; Author: Jack Stinchcombe
  ; License: MIT
  ;
  ; Description:
  ;   A collection of assembly macros for Z80 16-bit arithmetic operations using
  ;   SJASMPlus syntax. These macros simplify common patterns for manipulating
  ;   16-bit values in registers and memory.
  ;
  ;
  ; Key Points:
  ; These macros work on 16-bit values in register pairs and memory
  ;
  ; Many macros modify register A and flags
  ;
  ; Some macros using IX/IY offsets assume signed offsets, and some use unsigned offets - check each macro carefully
  ;
  ; Some macros temporarily use register pairs for intermediate calculations
  ;
  ;
  ; ============================================================================

  IFNDEF MACRO16BITMATHS
  DEFINE MACRO16BITMATHS

  ; ----------------------------------------------------------------------------
  ; ADD_BC_DE
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds DE to BC register pair (BC = BC + DE).
  ;
  ; Side effects:
  ;   Preserves HL by pushing/popping; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add bc, de
  ;
  ; Usage:
  ;   ADD_BC_DE
  ; ----------------------------------------------------------------------------
  MACRO ADD_BC_DE
      push hl
      ld h, b
      ld l, c
      add hl, de
      ld b, h
      ld c, l
      pop hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_BC_HL
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds HL to BC register pair (BC = BC + HL).
  ;
  ; Side effects:
  ;   Uses EX_BC_HL macro; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add bc, hl
  ;
  ; Usage:
  ;   ADD_BC_HL
  ; ----------------------------------------------------------------------------
  MACRO ADD_BC_HL
      EX_BC_HL
      add hl, bc
      EX_BC_HL
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_BC_BC
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Doubles BC register pair (BC = BC + BC, equivalent to SLA BC).
  ;
  ; Side effects:
  ;   Modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add bc, bc  or  sla bc
  ;
  ; Usage:
  ;   ADD_BC_BC
  ; ----------------------------------------------------------------------------
  MACRO ADD_BC_BC
      sla c
      rl b
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_BC_SP
  ; ---------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds SP to BC register pair (BC = BC + SP). Note: This is slow!
  ;
  ; Side effects:
  ;   Uses EX_BC_HL macro; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add bc, sp
  ;
  ; Usage:
  ;   ADD_BC_SP
  ; ----------------------------------------------------------------------------
  MACRO ADD_BC_SP
      EX_BC_HL
      add hl, sp
      EX_BC_HL
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_HL_A
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds register A to HL register pair (HL = HL + A), where A is unsigned.
  ;
  ; Side effects:
  ;   Corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add hl, a
  ;
  ; Usage:
  ;   ADD_HL_A
  ; ----------------------------------------------------------------------------
  MACRO ADD_HL_A
      add a, l    ; 7 ticks
      ld l, a     ; 4 ticks
      adc a, h    ; 4 ticks
      sub l       ; 4 ticks
      ld h, a     ; 4 ticks
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_BC_A
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds register A to BC register pair (BC = BC + A), where A is unsigned.
  ;
  ; Side effects:
  ;   Corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add bc, a
  ;
  ; Usage:
  ;   ADD_BC_A
  ; ----------------------------------------------------------------------------
  MACRO ADD_BC_A
      add a, c
      ld c, a
      adc a, b
      sub c
      ld b, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_DE_A
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds register A to DE register pair (DE = DE + A), where A is unsigned.
  ;
  ; Side effects:
  ;   Corrupts register A; modifies flags. Takes 23 ticks.
  ;
  ; Z80 Equivalent:
  ;   add de, a
  ;
  ; Usage:
  ;   ADD_DE_A
  ; ----------------------------------------------------------------------------
  MACRO ADD_DE_A
      add a, e    ; 7
      ld e, a     ; 4
      adc a, d    ; 4
      sub e       ; 4
      ld d, a     ; 4
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_IX_A
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds register A to IX register pair (IX = IX + A), where A is unsigned.
  ;
  ; Side effects:
  ;   Corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add ix, a
  ;
  ; Usage:
  ;   ADD_IX_A
  ; ----------------------------------------------------------------------------
  MACRO ADD_IX_A
      add a, ixl
      ld ixl, a
      adc a, ixh
      sub ixl
      ld ixh, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_IY_A
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds register A to IY register pair (IY = IY + A), where A is unsigned.
  ;
  ; Side effects:
  ;   Corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add iy, a
  ;
  ; Usage:
  ;   ADD_IY_A
  ; ----------------------------------------------------------------------------
  MACRO ADD_IY_A
      add a, iyl
      ld iyl, a
      adc a, iyh
      sub iyl
      ld iyh, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_IY_C
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds register C to IY register pair (IY = IY + C), where C is unsigned.
  ;
  ; Side effects:
  ;   Uses and corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add iy, c
  ;
  ; Usage:
  ;   ADD_IY_C
  ; ----------------------------------------------------------------------------
  MACRO ADD_IY_C
      ld a, c
      add a, iyl
      ld iyl, a
      adc a, iyh
      sub iyl
      ld iyh, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_IXPLUS_A n
  ; --------------
  ; Parameters:
  ;   n - signed 8-bit IX offset
  ;
  ; Description:
  ;   Adds register A to the 16-bit value at (IX+n), where A is unsigned.
  ;   (IX+n) is treated as a 16-bit little-endian value.
  ;
  ; Side effects:
  ;   Corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add (ix+n), a
  ;
  ; Usage:
  ;   ADD_IXPLUS_A 5
  ; ----------------------------------------------------------------------------
  MACRO ADD_IXPLUS_A n
      add a, (ix + n)
      ld (ix + n), a
      adc a, (ix + n+1)
      sub (ix + n)
      ld (ix + n+1), a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_HL_UNSIGNED_8BITVAL v
  ; -------------------------
  ; Parameters:
  ;   v - unsigned 8-bit value or register
  ;
  ; Description:
  ;   Adds an 8-bit unsigned value to HL register pair (HL = HL + v).
  ;
  ; Side effects:
  ;   Uses and corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add hl, v
  ;
  ; Usage:
  ;   ADD_HL_UNSIGNED_8BITVAL 42
  ; ----------------------------------------------------------------------------
  MACRO ADD_HL_UNSIGNED_8BITVAL v
      ld a, v
      ADD_HL_A
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_DE_UNSIGNED_8BITVAL v
  ; -------------------------
  ; Parameters:
  ;   v - unsigned 8-bit value or register
  ;
  ; Description:
  ;   Adds an 8-bit unsigned value to DE register pair (DE = DE + v).
  ;
  ; Side effects:
  ;   Uses and corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add de, v
  ;
  ; Usage:
  ;   ADD_DE_UNSIGNED_8BITVAL 100
  ; ----------------------------------------------------------------------------
  MACRO ADD_DE_UNSIGNED_8BITVAL v
      ld a, v
      ADD_DE_A
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD_HL_VAL val
  ; --------------
  ; Parameters:
  ;   val - 16-bit immediate value
  ;
  ; Description:
  ;   Adds a 16-bit immediate value to HL register pair (HL = HL + val).
  ;
  ; Side effects:
  ;   Preserves DE by pushing/popping; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add hl, val
  ;
  ; Usage:
  ;   ADD_HL_VAL 1000
  ; ----------------------------------------------------------------------------
  MACRO ADD_HL_VAL val
      push de
      ld de, val
      add hl, de
      pop de
  ENDM

  ; ----------------------------------------------------------------------------
  ; SUB_DE_UNSIGNED_8BITVAL val
  ; ---------------------------
  ; Parameters:
  ;   val - unsigned 8-bit value or register (not A)
  ;
  ; Description:
  ;   Subtracts an 8-bit unsigned value from DE register pair (DE = DE - val).
  ;
  ; Side effects:
  ;   Corrupts register A; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   sub de, val
  ;
  ; Usage:
  ;   SUB_DE_UNSIGNED_8BITVAL 50
  ; ----------------------------------------------------------------------------
  MACRO SUB_DE_UNSIGNED_8BITVAL val
      ld a, e
      sub val
      ld e, a
      ld a, d
      sbc 0
      ld d, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; BIT_N_DEPTR n
  ; -------------
  ; Parameters:
  ;   n - bit number (0-7)
  ;
  ; Description:
  ;   Tests bit n of the byte pointed to by DE register pair.
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   bit n, (de)
  ;
  ; Usage:
  ;   BIT_N_DEPTR 7
  ; ----------------------------------------------------------------------------
  MACRO BIT_N_DEPTR n
      ex de, hl
      bit n, (hl)
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG16_IX
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Negates the IX register pair (IX = -IX).
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Source:
  ;   http://z80-heaven.wikidot.com/optimization
  ;
  ; Usage:
  ;   NEG16_IX
  ; ----------------------------------------------------------------------------
  MACRO NEG16_IX
      xor a
      sub ixl
      ld ixl, a
      sbc a, a
      sub ixh
      ld ixh, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG16_HL
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Negates the HL register pair (HL = -HL).
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Source:
  ;   http://z80-heaven.wikidot.com/optimization
  ;
  ; Usage:
  ;   NEG16_HL
  ; ----------------------------------------------------------------------------
  MACRO NEG16_HL
      xor a
      sub l
      ld l, a
      sbc a, a
      sub h
      ld h, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG_HL
  ; ------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Alias for NEG16_HL. Negates the HL register pair (HL = -HL).
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Usage:
  ;   NEG_HL
  ; ----------------------------------------------------------------------------
  MACRO NEG_HL
      NEG16_HL
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG16_HLPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Negates the signed 16-bit value pointed to by HL ((HL) = -(HL)).
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Source:
  ;   http://z80-heaven.wikidot.com/optimization
  ;
  ; Usage:
  ;   NEG16_HLPTR
  ; ----------------------------------------------------------------------------
  MACRO NEG16_HLPTR
      xor a
      sub (hl)
      ld (hl), a
      sbc a, a
      inc hl
      sub (hl)
      ld (hl), a
      dec hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS16_HLPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts the signed 16-bit value pointed to by HL to its absolute value.
  ;   ((HL) = abs((HL)))
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Usage:
  ;   ABS16_HLPTR
  ; ----------------------------------------------------------------------------
  MACRO ABS16_HLPTR
      inc hl
      bit 7, (hl)
      jr z, .end
      dec hl
      xor a
      sub (hl)
      ld (hl), a
      sbc a, a
      inc hl
      sub (hl)
      ld (hl), a
.end:
      dec hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS16_DEPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts the signed 16-bit value pointed to by DE to its absolute value.
  ;   ((DE) = abs((DE)))
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL; uses register A; modifies flags.
  ;
  ; Usage:
  ;   ABS16_DEPTR
  ; ----------------------------------------------------------------------------
  MACRO ABS16_DEPTR
      ex de, hl
      ABS16_HLPTR
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG16_DEPTR
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Negates the signed 16-bit value pointed to by DE ((DE) = -(DE)).
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL; uses register A; modifies flags.
  ;
  ; Source:
  ;   Derived from http://z80-heaven.wikidot.com/optimization
  ;
  ; Usage:
  ;   NEG16_DEPTR
  ; ----------------------------------------------------------------------------
  MACRO NEG16_DEPTR
      ex de, hl
      xor a
      sub (hl)
      ld (hl), a
      sbc a, a
      inc hl
      sub (hl)
      ld (hl), a
      dec hl
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG16_DE
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Negates the DE register pair (DE = -DE).
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Source:
  ;   http://z80-heaven.wikidot.com/optimization
  ;
  ; Usage:
  ;   NEG16_DE
  ; ----------------------------------------------------------------------------
  MACRO NEG16_DE
      xor a
      sub e
      ld e, a
      sbc a, a
      sub d
      ld d, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; NEG16_BC
  ; --------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Negates the BC register pair (BC = -BC).
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Source:
  ;   http://z80-heaven.wikidot.com/optimization
  ;
  ; Usage:
  ;   NEG16_BC
  ; ----------------------------------------------------------------------------
  MACRO NEG16_BC
      xor a
      sub c
      ld c, a
      sbc a, a
      sub b
      ld b, a
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS_HL
  ; ------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts HL register pair to its absolute value (DE = abs(DE)).
  ;
  ; Side effects:
  ;   Uses NEG16_HL macro; modifies A and flags.
  ;
  ; Usage:
  ;   ABS_DE
  ; ----------------------------------------------------------------------------
  MACRO ABS_HL
      bit 7, h
      jr z, .end
      NEG16_HL
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS_DE
  ; ------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts DE register pair to its absolute value (DE = abs(DE)).
  ;
  ; Side effects:
  ;   Uses NEG_DE macro; modifies A and flags.
  ;
  ;
  ; Usage:
  ;   ABS_DE
  ; ----------------------------------------------------------------------------
  MACRO ABS_DE
      bit 7, d
      jr z, .end
      NEG16_DE
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ABS_BC
  ; ------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Converts BC register pair to its absolute value (BC = abs(BC)).
  ;
  ; Side effects:
  ;   Uses NEG16_BC macro; modifies A and flags.
  ;
  ;
  ; Usage:
  ;   ABS_BC
  ; ----------------------------------------------------------------------------
  MACRO ABS_BC
      bit 7, b
      jr z, .end
      NEG16_BC
.end:
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_DE_BC
  ; -----------
  ; Parameters:
  ;   none
  ;
  ; Description:
  ;   Adds BC to DE register pair (DE = DE + BC).
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL; modifies flags.
  ;
  ; Usage:
  ;   ADD16_DE_BC
  ; ----------------------------------------------------------------------------
  MACRO ADD16_DE_BC
      ex de, hl
      add hl, bc
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_ADDR_DE addr
  ; ------------------
  ; Parameters:
  ;   addr - memory address containing 16-bit value
  ;
  ; Description:
  ;   Adds DE to the 16-bit value at memory address ((addr) = (addr) + DE).
  ;
  ; Side effects:
  ;   Preserves HL by pushing/popping; modifies flags.
  ;
  ; Usage:
  ;   ADD16_ADDR_DE myVariable
  ; ----------------------------------------------------------------------------
  MACRO ADD16_ADDR_DE addr
      push hl
      ld hl, (addr)
      add hl, de
      ld (addr), hl
      pop hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_ADDR addr, val
  ; --------------------
  ; Parameters:
  ;   addr - memory address containing 16-bit value
  ;   val  - 16-bit immediate value to add
  ;
  ; Description:
  ;   Adds a 16-bit value to the 16-bit value at memory address ((addr) = (addr) + val).
  ;
  ; Side effects:
  ;   Preserves HL and DE by pushing/popping; modifies flags.
  ;
  ; Usage:
  ;   ADD16_ADDR myVariable, 1000
  ; ----------------------------------------------------------------------------
  MACRO ADD16_ADDR addr, val
      push hl
      push de
      ld hl, (addr)
      ld de, val
      add hl, de
      ld (addr), hl
      pop de
      pop hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_ADDR_A addr
  ; -----------------
  ; Parameters:
  ;   addr - memory address containing 16-bit value
  ;
  ; Description:
  ;   Adds register A to the 16-bit value at memory address ((addr) = (addr) + A).
  ;
  ; Side effects:
  ;   Preserves HL by pushing/popping; uses ADD_HL_A macro; modifies flags.
  ;
  ; Usage:
  ;   ADD16_ADDR_A myVariable
  ; ----------------------------------------------------------------------------
  MACRO ADD16_ADDR_A addr
      push hl
      ld hl, (addr)
      ADD_HL_A
      ld (addr), hl
      pop hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_ADDR_ADDR addr1, addr2
  ; ----------------------------
  ; Parameters:
  ;   addr1 - destination memory address
  ;   addr2 - source memory address
  ;
  ; Description:
  ;   Adds the 16-bit value at addr2 to the 16-bit value at addr1 ((addr1) = (addr1) + (addr2)).
  ;
  ; Side effects:
  ;   Preserves HL and DE by pushing/popping; modifies flags.
  ;
  ; Usage:
  ;   ADD16_ADDR_ADDR var1, var2
  ; ----------------------------------------------------------------------------
  MACRO ADD16_ADDR_ADDR addr1, addr2
      push hl
      push de
      ld hl, (addr2)
      ex de, hl
      ld hl, (addr1)
      add hl, de
      ld (addr1), hl
      pop de
      pop hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADC16_HL_NUM num
  ; ----------------
  ; Parameters:
  ;   num - 16-bit immediate value
  ;
  ; Description:
  ;   Adds a 16-bit immediate value to HL with carry (HL = HL + num + carry).
  ;
  ; Side effects:
  ;   Preserves DE by pushing/popping; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   adc hl, nn
  ;
  ; Usage:
  ;   ADC16_HL_NUM 500
  ; ----------------------------------------------------------------------------
  MACRO ADC16_HL_NUM num
      push de
      ld de, num
      adc hl, de
      pop de
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_HL_IXPLUS idx
  ; -------------------
  ; Parameters:
  ;   idx - signed 8-bit IX offset
  ;
  ; Description:
  ;   Adds the 16-bit value at (IX+idx) to HL (HL = HL + (IX+idx)).
  ;
  ; Side effects:
  ;   Preserves DE by pushing/popping; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add hl, (ix+nn)
  ;
  ; Usage:
  ;   ADD16_HL_IXPLUS 10
  ; ----------------------------------------------------------------------------
  MACRO ADD16_HL_IXPLUS idx
      push de
      ld e, (ix + idx)
      ld d, (ix + idx+1)
      add hl, de
      pop de
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_DE_IXPLUS idx
  ; -------------------
  ; Parameters:
  ;   idx - signed 8-bit IX offset
  ;
  ; Description:
  ;   Adds the 16-bit value at (IX+idx) to DE (DE = DE + (IX+idx)).
  ;
  ; Side effects:
  ;   Temporarily exchanges DE and HL; uses ADD16_HL_IXPLUS macro; modifies flags.
  ;
  ; Z80 Equivalent:
  ;   add de, (ix+n)
  ;
  ; Usage:
  ;   ADD16_DE_IXPLUS 5
  ; ----------------------------------------------------------------------------
  MACRO ADD16_DE_IXPLUS idx
      ex de, hl
      ADD16_HL_IXPLUS idx
      ex de, hl
  ENDM

  ; ----------------------------------------------------------------------------
  ; ADD16_IX idx1, idx2
  ; -------------------
  ; Parameters:
  ;   idx1 - signed 8-bit IX offset (destination)
  ;   idx2 - signed 8-bit IX offset (source)
  ;
  ; Description:
  ;   Adds the 16-bit value at (IX+idx2) to the 16-bit value at (IX+idx1).
  ;   ((IX+idx1) = (IX+idx1) + (IX+idx2))
  ;
  ; Side effects:
  ;   Uses register A; modifies flags.
  ;
  ; Usage:
  ;   ADD16_IX 0, 2
  ; ----------------------------------------------------------------------------
  MACRO ADD16_IX idx1, idx2
      ld a, (ix + idx1)
      add a, (ix + idx2)
      ld (ix + idx1), a
      ld a, (ix + idx1+1)
      adc a, (ix + idx2+1)
      ld (ix + idx1+1), a
  ENDM

  ENDIF
