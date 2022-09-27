;======================================
;
;======================================
CREATE          lda FRAME
                and #$07
                beq _Q30

                jmp _Q32

_Q30            ldx #$00
                lda EGGP
                bne _Q50

                jmp _CRTEST

_Q50            lda EGGSCH
                sta zpSCRH
                lda EGGSCL
                sta zpSCRL
                lda (zpSCRL,X)
                cmp #$D8
                bne _Q31

                dec EGSTAY              ; EGG=7
                lda EGSTAY
                and #$07
                bne _Q32

                lda (zpSCRL,X)          ; DEC EGG
                sec
                sbc #$01
                sta (zpSCRL,X)
_Q32            rts

_Q31            sec
                sbc #$01
                sta (zpSCRL,X)
                cmp #$D0
                beq _PLSNK

                jmp _Q32

_PLSNK          ldx #$00
                lda RANDOM              ; CHANCE OF NEW COLR
                bmi _PP0
                bpl _PP2                ; UNC

_PP0            lda #$10                ; PURSUE PL0
                bne _Q34                ; UNC

_PP2            lda #$30                ; PURSUE PL2
_Q34            sta (zpSCRL,X)
                inc NUMSNK
                ldx #$00
                stx EGGP
_NXTSX0         lda Z0X,X
                beq _SVZCOR

                inx
                txa
                and #$0F
                bne _NXTSX0

;--------------------------------------
                brk
;--------------------------------------

_SVZCOR         stx SNKIDX
                jsr SCTOXY

                ldx SNKIDX
                sta Z0X,X
                tya
                sta Z0Y,X
                lda #$01
                sta DIRPZ0,X
                lda EGGSCL
                sta SCRLZ0,X
                lda EGGSCH
                sta SCRHZ0,X
                jmp _Q32

_CRTEST         lda NUMSNK
                cmp #$0A
                bcs _Q32                ; ALREADY 10

                lda RANDOM
                cmp CRECRI
                bcc _GOCREA

                jmp _Q32

_GOCREA         jsr RANDSC

                lda (zpSCRL,X)
                bne _Q1RTS

                lda zpSCRH              ; BLANK UNDER?
                sta zpSCRH+2
                lda zpSCRL
                clc
                adc #$28
                bcc _Q45

                inc zpSCRH+2
_Q45            sta zpSCRL+2
                ldx #$02                ; UNDER SQ
                lda (zpSCRL,X)
                bne _Q1RTS

                lda #$07                ; BLANK
                sta (zpSCRL,X)          ; X=2
                lda #$DF                ; NEW EGG
                ldx #$00
                sta (zpSCRL,X)
                sta EGGP                ; EGG PRESENT
                lda zpSCRL
                sta EGGSCL
                lda zpSCRH
                sta EGGSCH
_Q1RTS          rts


;======================================
;
;======================================
RANDSC          .proc
                lda RANDOM
                and #$1F
                ora #$1C
                sta zpSCRH
                lda RANDOM
                sta zpSCRL
                cmp #$C8
                bcs _TESLOW

                cmp #$20
                bcc L9BB4

                sta zpSCRH+4
                lda #$02
                sta (zpSCRL+4),Y
                rts

_TESLOW         lda zpSCRH
                cmp #$1F
                beq RANDSC

                rts
                .endproc


;======================================
;
;--------------------------------------
; ZY INTO Y, ZX INTO A
;======================================
SCTOXY          lda zpSCRH
                sec
                sbc #$1B
                tax
                lda zpSCRL
                ldy #$02
                bne _X2

_SUB40A         iny
                sbc #$28
                bcs _SUB40A

_X2             dex
                sec
                bne _SUB40A

_SUB40B         iny
                sbc #$28
                cmp #$40
                bcs _SUB40B

                sec
                sbc #$0D
L9BB4           rts

;--------------------------------------
;--------------------------------------

                .fill 11,$00
