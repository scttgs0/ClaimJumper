
;======================================
;
;======================================
SMOOTH          .proc
                lda DIRP
                bpl _NEG

                ldx #$00
                lda (zpSCRL,X)
                and #$0F
                cmp #$09
                beq _NEWDIR

                lda (zpSCRL,X)
                tay
                iny
                tya
                sta (zpSCRL,X)

                lda DIRP
                sta DIRZF
                ldx #$02
                jsr FINDSC              ; X=2

                lda (zpSCRL,X)
                tay
                iny
                tya
                sta (zpSCRL,X)
                rts

_NEG            ldx #$00
                lda (zpSCRL,X)
                and #$0F
                beq _NEWDIR

                lda (zpSCRL,X)
                tay
                dey
                tya
                sta (zpSCRL,X)

                lda DIRP
                sta DIRZF
                ldx #$02
                jsr FINDSC              ; X=2

                lda (zpSCRL,X)
                tay
                dey
                tya
                sta (zpSCRL,X)
                rts

_NEWDIR         jsr FNEWDR

                ldx #$04
                jsr FINDSC              ; NEWSC

                lda (zpSCRL,X)          ; X=4
                cmp #$05
                bcc _Q5

                rts

_Q5             ldx #$00
                asl SMOOTH,X
                lda (zpSCRL,X)
                cmp #$2C
                bcs _RED                ; BAG TUMB

                ldy #$00
                sty ADCOLP              ; SNK
                sty ADCOLN
                bcc _Q13                ; UNC

_RED            ldy #$20
                sty ADCOLP
                sty ADCOLN
_Q13            ldx #$04
                lda (zpSCRL,X)
                beq _GOMOVE

                cmp #$01
                bne _Q43

                jsr SMASH0

                dec NUMBT0
_QSM03          jsr SN5V2

                ldy #$20
                sty ADCOLN
                bne _GOMOVE             ; UNC

_Q43            cmp #$02
                beq _Q44

                cmp #$03
                beq _QSM03

                cmp #$04
                beq _Q443

_Q44            jsr SMASH2

                dec NUMBT2
_Q443           jsr SN6V4

                ldy #$00
                sty ADCOLN
_GOMOVE         lda DIRZF
                sta DIRN
                lda DIRP
                sta DIRZF
                ldx #$02
_LA3EE          jsr FINDSC              ; OLDSC

                lda #$00
                sta (zpSCRL,X)          ; ERASE OLDZ
                lda DIRN
                bmi _Q6
                beq _Q7

                ldx #$00                ; DOWN
                lda #$11
                clc
                adc ADCOLP
                sta (zpSCRL,X)
                ldx #$04
                lda #$16
                adc ADCOLN
                sta (zpSCRL,X)
                inc ZY_
                lda #$81
                sta DIRP
                jmp _NEWDUN

_Q7             ldx #$00
                lda #$21                ; RIGHT
                clc
                adc ADCOLP
                sta (zpSCRL,X)
                ldx #$04
                lda #$26
                adc ADCOLN
                sta (zpSCRL,X)
                inc ZX_
                lda #$80
                sta DIRP
                jmp _NEWDUN

_Q6             and #$01                ; LEFT
                bne _Q8

                ldx #$00
                lda #$28
                clc
                adc ADCOLP
                sta (zpSCRL,X)
                ldx #$04
                lda #$23
                adc ADCOLN
                sta (zpSCRL,X)
                dec ZX_
                lda #$00
                sta DIRP
                jmp _NEWDUN

_Q8             ldx #$00                ; UP
                lda #$18
                clc
                adc ADCOLP
                sta (zpSCRL,X)
                ldx #$04
                lda #$13
                adc ADCOLN
                sta (zpSCRL,X)
                dec ZY_
                lda #$01
                sta DIRP
_NEWDUN         ldy SAVEZ
                lda DIRP
                sta DIRPZ0,Y
                lda ZX_
                sta Z0X,Y
                lda ZY_
                sta Z0Y,Y
                lda zpSCRL+4
                sta SCRLZ0,Y
                lda zpSCRH+4
                sta SCRHZ0,Y
                rts
                .endproc


;======================================
;
;======================================
FINDSC          .proc
                lda zpSCRH
                sta zpSCRH,X
                lda DIRZF
                bmi _FNEG

                and #$01
                bne _FDWN

                lda zpSCRL
                clc
                adc #$01
                sta zpSCRL,X            ; ABS.INDEXED
                bcc _Q12

                inc zpSCRH,X
                rts

_FDWN           lda zpSCRL
                clc
                adc #$28
                sta zpSCRL,X
                bcc _Q12

                inc zpSCRH,X
                rts

_FNEG           and #$01
                beq _FLEFT

                lda zpSCRL
                sec
                sbc #$28
                sta zpSCRL,X
                bcs _Q12

                dec zpSCRH,X
                rts

_FLEFT          lda zpSCRL
                sec
                sbc #$01
                sta zpSCRL,X
                bcs _Q12

                dec zpSCRH,X
_Q12            rts
                .endproc


;======================================
;
;======================================
FNEWDR          .proc
                ldy #$00
                lda (zpSCRL),Y
                cmp #$2C                ; SET Y
                bcc _QSS1               ; FOR SNK OR TMB

                iny
_QSS1           ;--lda RANDOM
                cmp CHANC0,Y            ; Y=0,1
                bcs _Q19

                ;--lda RANDOM
                and #$81
                sta DIRZF
                rts

_Q19            ldx #$00
                lda (zpSCRL,X)
                cmp #$2C
                bcs _Q14

                ldy #$00
                beq _Q15

_Q14            ldy #$04
_Q15            sty PNUM
                lda zpXP0,Y
                lsr A
                lsr A
                sec
                sbc ZX_
                jsr ABSX

                sta XDIF
                lda zpYP0,Y
                lsr A
                lsr A
                lsr A
                sec
                sbc ZY_
                jsr ABSX

                cmp XDIF
                beq _DIFEQ

                ldx #$FF
                stx PROB
                bcc _XBIG

_YBIGLP         asl XDIF
                lsr PROB
                beq _Q17

                cmp XDIF
                bcc _Q17

                bcs _YBIGLP

_Q17            inc PROB
                lda PROB
                eor #$FF
                sta PROB
                jmp _Q18

_DIFEQ          lda #$7F
                sta PROB
                jmp _Q18

_XBIG           sta YDIF
                lda XDIF
_XBIGLP         asl YDIF
                lsr PROB
                beq _Q18

                cmp YDIF
                bcc _Q18

                bcs _XBIGLP

_Q18            ldy PNUM
                lda PROB
                ;--cmp RANDOM
                bcc _FDIRX

                lda zpYP0,Y
                lsr A
                lsr A
                lsr A
                sec
                sbc ZY_
                bpl _Q2

                lda #$81
                sta DIRZF
                rts

_Q2             lda #$01
                sta DIRZF
                rts

_FDIRX          lda zpXP0,Y
                lsr A
                lsr A
                sec
                sbc ZX_
                bpl _Q3

                lda #$80
                sta DIRZF
                rts

_Q3             lda #$00
                sta DIRZF
                rts
                .endproc


;======================================
; Absolute |X|
;======================================
ABSX            .proc
                bpl _Q1

                eor #$FF
                clc
                adc #$01
_Q1             rts
                .endproc


;======================================
; Sound-5
;======================================
SN5V2           .proc
                lda ADCOLP
                beq _QSN1

                lda #$20                ; SN7,EAT
                ;--sta AUD2
                lda #$70
                sta DUR2
                rts

_QSN1           lda #$A0                ; SNK
                ;--sta AUD2                ; TO TUM
                lda #$50
                sta DUR2
                ldx #$00
                jsr PLUS_

                rts
                .endproc


;======================================
; Sound-6
;======================================
SN6V4           .proc
                lda ADCOLP
                cmp #$20
                beq _QSN2

                lda #$20                ; SN7,EAT
                ;--sta AUD4
                lda #$70
                sta DUR4
                rts

_QSN2           lda #$A0                ; TUM
                ;--sta AUD4                ; TO SNK
                lda #$60
                sta DUR4
                ldx #$02
                jsr PLUS_

                rts
                .endproc


;======================================
;
;======================================
SMASH0          .proc
                ldx NUMBT0
                txa
                tay
                beq DEBUG
                bne SMASH2._TESLP       ; UNC

                .endproc

;======================================
;
;======================================
SMASH2          .proc
                lda NUMBT2
                tay
                ora #$10
                tax
_TESLP          lda L06C0,X
                cmp zpSCRL+4
                bne _NXTES

                lda L06C8,X
                cmp zpSCRH+4
                beq _SQLP

_NXTES          dex
                dey
                bne _TESLP

;--------------------------------------
                brk
;--------------------------------------

_SQLP           lda L06C1,X
                sta L06C0,X
                lda L06C9,X
                sta L06C8,X
                inx
                iny
                tya
                cmp #$07
                bne _SQLP

                rts
                .endproc

;--------------------------------------
DEBUG           brk
;--------------------------------------


;======================================
;
;======================================
PLUS_           .proc
                sed
                lda DIGL0,X
                clc
                adc #$10
                sta DIGL0,X
                lda DIGH0,X
                adc #$00
                sta DIGH0,X
                cld
                rts
                .endproc


;--------------------------------------
                .fill 2,$00
;--------------------------------------
