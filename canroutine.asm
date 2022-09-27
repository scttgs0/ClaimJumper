;======================================
;
;======================================
CANROU          jsr FLASH

                lda STATCN
                beq _QNUT

                jmp _PRESNT

_QNUT           lda RANDOM
                and #$0F                ; CHECK 4/SEC
                bne _QCRTS

                lda MCNT4
                bne _QCRTS

                lda RANDOM
                cmp CANCRI
                bcs _QCRTS

                jsr RANCAN              ; NEAR

                ldx #$00
                lda (zpSCRL,X)
                bne _QCRTS

                inc zpSCRL
                lda (zpSCRL,X)
                bne _QCRTS

                inc zpSCRL
                lda (zpSCRL,X)
                cmp #$07
                beq _QCRTS

                dec zpSCRL
                jsr SCTOXY_2

                asl A
                asl A
                sta zpXP1
                tya
                asl A
                asl A
                asl A
                clc
                adc #$09
                sta zpYP1
                sec
                sbc zpYP0
                jsr ABSVAL

                cmp #$10                ; <F TOO CLOSE
                bcs _QC2

_QCRTS          rts

_QC2            lda zpYP1
                sec
                sbc zpYP2
                jsr ABSVAL

                cmp #$10
                bcs _QC3

                rts

_QC3            lda zpXP1
                sec
                sbc zpXP0
                jsr ABSVAL

                cmp #$0C
                bcs _QC4

                rts

_QC4            lda zpXP1
                sec
                sbc zpXP2
                jsr ABSVAL

                cmp #$0C
                bcs _PLCAN

                rts

_PLCAN          ldx #$FF
                stx FRAMM
                lda #$01
                sta STATCN
                lda #$08
                sta CNTYPE
                lda #$2C
                sta PCOLR1
                jsr SETCAN
                jsr DRAWCN

                lda #$BC
                sta DUR4
                lda #$A0
                sta AUD4
_CRTS           rts

_PRESNT         bpl _UNOWND

                jmp _OWNED

_UNOWND         lda CNTYPE
                cmp #$FF
                bne _NOWAIT

                lda MCNT4
                bne _CRTS

                sta CNTYPE
                jsr DRSTOR

                lda #$24                ; NEW P1
                sta zpYP1               ; COORDS
                lda #$68
                sta zpXP1
                jsr SETCAN
                jsr DRAWCN

                rts

_NOWAIT         lda P1PL
                and #$05
                bne _CANCOL

                lda zpXP1
                cmp #$2E                ; XMN+-
                bcc _JEDGFL

                cmp #$CB                ; XMX+-
                bcc _UNORTS

_JEDGFL         jsr SETCAN
                jsr ERASE_2

                ldx #$02                ; XP1 OFFSET
                jsr EDGFLY

                jmp _DR

_UNORTS         rts

_CANCOL         cmp #$05                ; SIMUL COLL?
                bne _COL1

                ldy STUK0
                bne _COL1

                ldy STUK2
                bne _COL1

                rts

_COL1           and #$01                ; P1 COLL?
                beq _COLP2

                ldy STUK0
                bne _COLP2

                ldy STRIG0
                beq _COLP2

                lda #$80
                sta STATCN
                lda CNTYPE
                beq _ACQBL0

                jsr DRSCAL

_ACQBL0         rts

_COLP2          lda P1PL
                and #$04
                beq _QC65

                lda STUK2
                bne _QC65

                lda STRIG1
                bne _QC6

_QC65           rts

_QC6            lda #$81
                sta STATCN
                lda CNTYPE
                beq _ACQBL2

                jsr DRSCAL

_ACQBL2         rts

_OWNED          jsr PRESTO

                lda STATCN
                and #$01                ; STATCN
                bne _P2OWN              ; STATCN 80 OR 81?

                jsr SETCAN
                jsr ERASE_2

                lda zpYP0
                clc
                adc #$08                ; CYPL
                sta zpYP1
                sta zpYP
                lda zpXP0
                sec
                sbc #$04                ; CXMI
                sta zpXP1
                sta HPOSP1
                lda STUK0
                beq _Q56

                ldx #$00
                jsr FLY

                jmp _DR

_Q56            lda STRIG0
                bne _DR

                ldx #$00
                jmp _SAVTES

_P0SAVD         inc SCOR0
                ldx SCOR0
                lda #$88                ; SMASHD CAN
                sta L1FB3,X
                jmp _ENCAN

_P2OWN          jsr SETCAN
                jsr ERASE_2

                lda zpYP2
                clc
                adc #$08                ; CYPL
                sta zpYP1
                sta zpYP
                lda zpXP2
                clc
                adc #$06                ; CXPL
                sta zpXP1
                sta HPOSP1
                lda STUK2
                beq _Q58

                ldx #$04
                jsr FLY

                jmp _DR

_Q58            lda STRIG1
                bne _DR

                ldx #$01
_SAVTES         lda #$01
                sta TRG0FL,X            ; 0,1
                lda GAMENO
                bne _LOSE

                lda CNTYPE
                bne _LOSE

                lda zpYP1
                cmp #$BF
                bcc _LOSE

                lda zpXP1
                cmp #$3B
                bcs _TRYP2
                bcc _P0SAVD             ; UNC

_TRYP2          cmp #$BE
                bcc _LOSE

                bcs _P2SAVD

_LOSE           lda #$01
                sta STATCN
                txa
                beq _P2BEL

                jsr SNBPV1_2

                jmp _DR

_P2BEL          jsr SNBPV3_2
_DR             jsr DRAWCN

                rts

_P2SAVD         inc SCOR2
                lda SCOR2
                eor #$FF
                and #$0F
                tax
                lda #$9F                ; SMASHT CAN
                sta L1FC5,X
_ENCAN          jsr SETCAN
                jsr ERASE_2

                lda #$00
                sta STATCN
                sta HPOSP1
                lda #$B5
                sta NoteAttack
                lda #$06
                sta MCNT4
                lda #$FF
                sta FRAMM
                rts


;======================================
;
;======================================
FLY             .proc
                lda #$01
                sta STATCN
                lda RANDOM
                bpl EDGFLY._ONEDIR

                .endproc

                ;[fall-through]


;======================================
;
;======================================
EDGFLY          .proc
                jsr HORFLY

                jmp _VERFLY

_ONEDIR         lda RANDOM
                bpl HORFLY

                jmp _VERFLY

_VERFLY         lda RANDOM
                bpl _SUBHOR

                lda zpYP0,X
                adc #$18
                cmp #$B8                ; YMAX
                bcc _YSTOR

                sbc #$28
                jmp _YSTOR

_SUBHOR         lda zpYP0,X
                sbc #$10
                cmp #$28                ; YMIN
                bcs _YSTOR

                adc #$28
_YSTOR          sta zpYP1
                sta zpYP
                rts
                .endproc


;======================================
;
;======================================
HORFLY          .proc
                lda RANDOM
                bpl _SUBVER

                lda zpXP0,X
                adc #$0C
                cmp #$C0                ; XMAX
                bcc _XSTOR

                sbc #$15
                jmp _XSTOR

_SUBVER         lda zpXP0,X
                sbc #$09
                cmp #$34                ; XMIN
                bcs _XSTOR

                adc #$15
_XSTOR          sta zpXP1
                sta HPOSP1
                rts
                .endproc


;======================================
;
;======================================
ERASE_2         .proc
                ldy #$0C
                lda #$00
_NXLN2          sta (zpYP),Y
                dey
                bpl _NXLN2

                rts
                .endproc


;======================================
;
;======================================
PRESTO          .proc
                lda STATCN
                cmp #$02
                bcc _PRTS

                lda CNTYPE
                beq _BILL

;   NUGGET
                lda M1PL
                and #$02
                beq _PRTS

                lda #$FF                ; NUGGET
                sta CNTYPE              ; TOWAIT
                lda #$C8
                sta PCOLR1              ; GREEN
                lda #$01
                sta STATCN
                jsr SETCAN
                jsr ERASE_2

                lda #$BA
                sta NoteAttack
                lda #$06
                sta MCNT4
                sta zpXP1
                pla
                pla
_PRTS           rts

_BILL           lda M1PL
                and #$02
                beq _PRTS

                pla
                pla
                lda #$B2                ; MUSIC
                sta NoteAttack
                lda #$03
                sta MCNT4
                lda STATCN
                cmp #$80
                beq STOHOU

                .endproc

                ;[fall-through]


;======================================
;
;======================================
P06BUL          .proc
                ldy #$0A
                lda #$7D
_Q76            sta L1BE1,Y
                dey
                bne _Q76

                ldx #$01
                bne STOHOU.L9E9B        ; UNC

                .endproc


;======================================
;
;======================================
STOHOU          .proc
                ldy #$0A
                lda #$7C
L9E93           sta L1BCB,Y
                dey
                bne L9E93

                ldx #$00
L9E9B           lda #$0A
                sta NUMBL0,X
                jsr SETCAN
                jsr ERASE_2

                lda #$00
                sta STATCN
                rts
                .endproc


;======================================
;
;======================================
DRSCAL          .proc
                lda PMSCAL
                ora #$0C
                sta PMSCAL
                lda #$00
                sta PMSTOR
                sta PMSTOR+3
                rts
                .endproc


;======================================
;
;======================================
DRSTOR          .proc
                lda #$08
                sta PMSTOR
                lda #$04
                sta PMSTOR+3
                lda PMSCAL
                and #$F3
                sta PMSCAL
                rts
                .endproc


;======================================
;
;======================================
RANCAN          .proc
                lda RANDOM
                and #$1F
                ora #$1C
                sta zpSCRH
                lda RANDOM
                sta zpSCRL
                cmp #$60
                bcs _TESLW2
                bcc _next1

_TESLW2         lda zpSCRH
                cmp #$1F
                beq RANCAN

_next1          lda RANDOM
                cmp #$C0
                bcs _next1

                cmp #$30
                bcc _next1

                tay
                sty zpSCRH+4
                sta (zpSCRL+4),Y
                rts
                .endproc


;======================================
;
;======================================
DRAWCN          .proc
                lda #$07
                tay
                clc
                adc CNTYPE
                tax
_NXLN1          lda STAMP_CANS,X        ; =CANS
                sta (zpYP),Y
                dex
                dey
                bpl _NXLN1

                rts
                .endproc


;======================================
;
;======================================
SETCAN          .proc
                lda #$0D                ; =P1BAS
                sta zpYBAS
                lda zpXP1
                sta zpXP
                sta HPOSP1
                lda zpYP1
                sta zpYP
                rts
                .endproc


;======================================
;
;======================================
ABSVAL          .proc
                bpl _QPL

                eor #$FF
                clc
                adc #$01
_QPL            rts
                .endproc


;======================================
; Sound-BP, Voice-1
;======================================
SNBPV1_2        .proc
                lda #$A0
                sta AUD1
                lda #$80
                sta DUR1
                rts
                .endproc


;======================================
; Sound-BP, Voice-3
;======================================
SNBPV3_2        .proc
                lda #$A0
                sta AUD3
                lda #$80
                sta DUR3
                rts
                .endproc


;======================================
;
;======================================
SCTOXY_2        .proc
                lda zpSCRH
                sec
                sbc #$1B
                tax
                lda zpSCRL
                ldy #$02
                bne _X2                 ; UNC

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
                rts
                .endproc


;======================================
;
;======================================
FLASH           lda FRAME
                and #$03
                bne _COLOK

                lda PCOLR1
                ldx STATCN
                bmi _OWNCOL

                eor #$02
                bne _STOCOL

_OWNCOL         ora #$02
_STOCOL         sta PCOLR1
_COLOK          lda STATCN
                bpl _TRIIN

                lda CNTYPE
                beq _FBILL

                cmp #$FF
                beq _M1OFF              ; WAITING NUGGET

                lda FRAME
                and #$08
                beq _M1OFF

                lda #$89                ; SCALE
                sta HPOSM1
                lda #$1C
                sta L1C58
                rts

_FBILL          lda FRAME
                and #$08
                beq _TRIIN

                lda GAMENO
                bne _STORE

                lda STATCN
                cmp #$81
                beq _P2ON

                ldx #$1D
                stx L1F8C
                lda BONUS0
                beq _FRTS

                bne _STORE

_P2ON           ldx #$1E
                stx L1FAB
                lda BONUS2
                beq _FRTS

_STORE          lda #$7F
                sta HPOSM1
_FRTS           rts

_TRIIN          lda #$07
                sta L1F8C
                sta L1FAB
_M1OFF          lda #$00
                sta HPOSM1
                lda #$07
                sta L1C58
                rts

;---
;---

                ldx #$00
                lda (zpSCRL,X)
                and #$0F
                cmp #$09
                beq $A01B

                lda (zpSCRL,X)
                tay
                iny
                tya
                sta (zpSCRL,X)
                lda DIRP
                sta DIRZF
                ldx #$02
                jsr L4130

                lda (zpSCRL,X)
                tay
                iny
                tya
                sta (zpSCRL,X)
                rts

;--------------------------------------
;--------------------------------------

                .byte $00,$4D,$AB,$00,$04,$F8,$9F
