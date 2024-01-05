
;======================================
; Music Routine
;======================================
MUSICROU        .proc
vDATAH1 = $91
vDATAL1 = $00
vDATAL2 = $58
vDATAL3 = $90
;---

                ldx #$00
                stx AUDC4
                lda #vDATAL1
                sta zpSCRL+4
                lda #vDATAH1
                sta zpSCRH+4
                jsr PROCES

                lda #vDATAL2
                sta zpSCRL+4
                ldx #$02
                jsr PROCES

                lda #vDATAL3
                sta zpSCRL+4
                ldx #$04
                jsr PROCES

                rts
                .endproc


;======================================
;
;======================================
CLEAR           .proc
                ldx #$05
_MLP            lda #$00
                sta NoteNumber,X
                lda #$02
                sta SOUND,X
                dex
                bpl _MLP

                rts
                .endproc


;======================================
;
;======================================
PROCES          .proc
                lda #$00
                sta NoteAttack
                sta DOTFL
                lda NoteDuration,X
                bne _SAMNOT

                lda #$01
                sta NoteAttack
                inc NoteNumber,X
                ldy NoteNumber,X
                cpy #$76
                bcs _ENSONG

                lda (zpSCRL+4),Y
                cmp #$FF
                bne _DOTOK

                lda #$01
                sta DOTFL
                iny
                inc NoteNumber,X
                lda (zpSCRL+4),Y
_DOTOK          lsr A
                lsr A
                lsr A
                lsr A
                lsr A
                lsr A
                sta NoteDURCOD
                lda (zpSCRL+4),Y
                and #$3F
                tay
                lda FTABLE,Y
                sta AUDF1,X
                ldy NoteDURCOD
                lda _DURTAB,Y
                sta NoteDuration,X
                ldy DOTFL
                beq _SAMNOT

                lsr A
                clc
                adc NoteDuration,X
                sta NoteDuration,X
_SAMNOT         dec NoteDuration,X
                beq _REST

                ldy NoteNumber,X
                lda (zpSCRL+4),Y
                and #$3F
                beq _REST

                lda NoteAttack
                bne _ATVOL

                lda NoteDuration,X
                cmp #$01
                beq _D1

                cmp #$02
                beq _D2

                lda #$A5
                cpx #$00
                beq _DUN

                lda #$A7
_DUN            sta AUDC1,X
                rts

_REST           lda #$A0
                bne _DUN

_D1             lda #$A2
                bne _DUN

_D2             lda #$A4
                bne _DUN

_ATVOL          lda #$A4
                bne _DUN

_ENSONG         ldx #$01
_NOTMV          lda FTABLE+1,X
                sta FTABLE,X
                inx
                cpx #$25
                bne _NOTMV

                lda FTABLE+$19
                sta FTABLE,X
                jsr CLEAR

                rts

;--------------------------------------

_DURTAB         .byte $08,$10,$20,$40,$10,$20,$40,$0F
                .byte $0F,$0F,$0F,$0F,$0F,$00,$00,$00
                .byte $00,$3F,$3F,$0F,$03

                .endproc

;--------------------------------------

