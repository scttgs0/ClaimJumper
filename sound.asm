
;======================================
;
;======================================
SOUND           .proc
                sta HITCLR
                lda #$00
                sta AUDCTL
                lda #$03
                sta SKCTL
                inc FRAMM
                ldx #$06
_NXVOI          lda MCNT1,X
                beq _STNDRD

                lda FRAMM
                and #$1F
                beq _NEXNOT

                lda VOL1,X
                beq _STNDRD

                lda FRAMM
                and #$07
                bne _DECVOI

                dec VOL1,X
_STOVOL         lda VOL1,X
                sta AUDC1,X
                jmp _DECVOI

_NEXNOT         dec NoteNumber,X
                dec MCNT1,X
                beq _ZVOL

                ldy NoteNumber,X
                lda VOLUME,Y
                sta VOL1,X
                lda FREQ,Y
                sta AUDF1,X
                jmp _STOVOL

_ZVOL           lda #$00
                sta VOL1,X
                sta DUR1,X
                beq _NOVOI

_STNDRD         ldy DUR1,X
                beq _NOVOI

                lda VOLUME,Y
                ora AUD1,X
                sta AUDC1,X
                lda FREQ,Y
                sta AUDF1,X
                inc DUR1,X
                lda DUR1,X
                cmp #$A0
                beq _DECVOI

                and #$0F
                beq _ZERODR

_DECVOI         dex
                dex
                bpl _NXVOI

                jmp STCOL._LAB02_BAD

_NOVOI          lda #$00
                sta AUDC1,X
                beq _DECVOI

_ZERODR         lda #$00
                sta DUR1,X
                beq _DECVOI
                bne _STOVOL             ; UNC

                jsr SOUND

                lda ADCOLP
                asl A
                asl A
                bcc _ZVOL

                rts
                .endproc

;--------------------------------------
;--------------------------------------

                .byte $00,$00
