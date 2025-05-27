  IFNDEF MACRO8BITMATHS
  DEFINE MACRO8BITMATHS

  MACRO MIN_UNSIGNED_A_VAL val
    cp val
    BRANCH_UNSIGNED_LT .end
    ld a, val
.end
  ENDM

  MACRO MAX_UNSIGNED_A_VAL val; A = max (A, val)
    cp val
    BRANCH_UNSIGNED_GTE .end
    ld a, val
  .end:
  ENDM

  MACRO ADD_ADDR_REG addr, reg
    ld a, (addr)
    add reg
    ld (addr), a
  ENDM


  MACRO ADD_ADDR_ADDR addr1, addr2; addr1=addr1+addr2

    push hl
    ld hl, addr2
    ld a, (addr1)
    add (hl)
    ld (addr1),a
    pop hl

  ENDM




  MACRO ADD_IX idx1, idx2; adc (ix+*), (ix+*)
    ld a, (ix + idx1)
    add (ix + idx2)
    ld (ix + idx1), a
  ENDM

  MACRO SUM_IX idx1, idx2, idx; (ix+idx1) = (ix+idx2) + (ix+idx3)
    ld a, (ix + idx2)
    add (ix + idx3)
    ld (ix + idx1), a
  ENDM

  MACRO NEG8_IXPLUS n; neg (ix+n); where (ix+n) is a signed 8 bit value; Uses up aF
    xor a
    sub (ix + n)
    ld (ix + n), a
  ENDM

  MACRO ABS8_IXPLUS n; neg (ix+n); where (ix+n) is a signed 8 bit value
    ld a, (ix + n)
    and 128; 1 clock cycle faster than bit 7,a
    jp z, .end
    neg
    ld (ix + n), a
.end:

  ENDM


  MACRO ABS8_A; absolute value of A if A is a signed value

    bit 7, a
    jp z, .end
    neg
.end:

  ENDM

  MACRO ABS8_HLPTR; absolute value of (hl); Borks A
    bit 7, (hl)
    jp nz, .end
    ld a, (hl)
    neg
    ld (hl), a
  .end:
  ENDM

  MACRO ABS8_DEPTR; absolute value of (de); Borks A
    ex de, hl
    bit 7, (hl)
    jp nz, .end
    ld a, (hl)
    neg
    ld (hl), a
    ex de, hl
  .end:
  ENDM

  MACRO RL_IYH

  ENDM

  ENDIF
