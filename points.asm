;======================================
;
;======================================
POINTS          .proc
                lda #$1F
                sta zpSCRH
                lda #$DE                ; P0POINT
                sta zpSCRL
                ldx #$00
                jsr SEPAR

                lda #$F5
                sta zpSCRL
                ldx #$02
                jsr SEPAR

                ldx #$00
                jsr TPOINT

                ldx #$02
                jsr TPOINT

                rts
                .endproc


;======================================
;
;======================================
SEPAR           .proc
                lda DIGH0,X             ; 0/2
                lsr A
                lsr A
                lsr A
                lsr A
                sta SEP_+0
                lda DIGH0,X
                and #$0F
                sta SEP_+1
                lda DIGL0,X
                lsr A
                lsr A
                lsr A
                lsr A
                sta SEP_+2
                lda DIGL0,X
                and #$0F
                sta SEP_+3

                ldy #$00
_T0LP           lda SEP_,Y
                bne _DISPLP

                iny
                cpy #$04
                bne _T0LP

_DISPLP         lda SEP_,Y
                tax
                clc
                adc #$56
                sta (zpSCRL),Y
                iny
                cpy #$05
                bne _DISPLP

                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
SCJUMP          inc HFLAG


;======================================
;
;======================================
TPOINT          .proc
                lda #$00
                ldy HFLAG
                bne _CHEK50

                lda DIGH0,X             ; T
_CHEK50         sed
                clc
                adc DIGH0,X             ; T
                cld
                bcs SCJUMP

                cmp #$50                ; T
                bcs _PTWIN

                rts

_PTWIN          pla
                pla
                pla
                pla

;   ENTES LEVEL
                inc HFLAG
                lda NoteAttack
                cmp #$BA
                bcs _ENLOOP

                lda #$C0
                sta NoteAttack
                lda #$07
                sta MCNT4
_ENLOOP         jsr ENDFR
                jsr STRTES
                jsr OP1TES
                jsr SOUND
                jsr FLHIGH

                lda HFLAG
                lsr A
                bne _ENLOOP

                lda #$08                ; TEST SEL BUT
                sta CONSOL
                lda CONSOL
                lsr A
                lsr A
                bcc _PUSHTC

                lda #$00
                sta SELFLG
                beq _ENLOOP             ; UNC

_PUSHTC         lda SELFLG
                beq _GOON

                bne _ENLOOP

_GOON           jmp CLRFL

                .endproc


;======================================
;
;======================================
FLHIGH          .proc
                lda FRAME
                and #$08
                bne _FLH
                beq CLRFL               ; UNC

_FLRTS          rts

_FLH            lda DIGH0
                cmp DIGH2
                beq _TRYLOW
                bcs _FLP0
                bcc _FLP2               ; UNC

_TRYLOW         lda DIGL0
                cmp DIGL2
                beq _FLRTS
                bcs _FLP0

_FLP2           lda #$55
                sta L1FF4
                rts

_FLP0           lda #$7F
                sta L1FE3
                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
CLRFL           .proc
                lda #$00
                sta L1FE3
                sta L1FF4
                rts
                .endproc

;--------------------------------------
;--------------------------------------

                .fill 7,$00
