;======================================
; Bullet Routine
;======================================
BUL             .proc
                jsr BUL0
                jsr BUL2

                rts
                .endproc


;======================================
;
;======================================
BUL0            .proc
                lda STBUL0
                bne _Q64

                rts

_Q64            lda M0PL
                and #$04
                bne _COWHT0

                lda zpXP2
                clc
                adc #$02
                cmp XM0
                bcs _Q65

                adc #$03
                cmp XM0
                bcc _Q65

                lda zpYP2
                cmp YM0
                bcs _Q65

                adc #$0D
                cmp YM0
                bcc _Q65

_COWHT0         lda #$00
                sta STBUL0
                jsr ERSM0

                lda STUK2
                bmi _C0RTS

                lda #$80+$3F
                sta STUK2
                lda #$90
                sta DUR3
                lda #$A0
                sta AUD3
_C0RTS          rts

_Q65            lda M0PF
                bne _GRAY0

                jmp Q70

_GRAY0          and #$0B
                beq _QB0

                ldx #$00
                stx BHITFL
                jmp HITROU

_QB0            lda YM0
                cmp #$50
                bcs Q70

                cmp #$1F
                bcc Q70

                lda XM0
                cmp #$48
                bcc _AREA0

                cmp #$B0
                bcc Q70

_AREA0          lda STBUL0
                bmi _LFTRT0

                cmp #$01
                beq Q70

                jsr WIDEN0

                lda XM0
                cmp #$7C
                bcc _UP2RT0

                lda #$82
                sta STBUL0
                bne BOUNC0

_UP2RT0         lda #$81
                sta STBUL0
                bne BOUNC0

_LFTRT0         lda XM0
                cmp #$7C
                bcc _LEFSD0

                lda STBUL0
                cmp #$81
                beq _BNCDN0

                jmp Q70

_LEFSD0         lda STBUL0
                cmp #$82
                beq _BNCDN0

                jmp Q70

_BNCDN0         lda #$01
                sta STBUL0
                bne BOUNC0

                .endproc


;--------------------------------------
;
;--------------------------------------
BOUNC0
Q70             .proc
                lda STBUL0
                bmi SIDEW0

                lsr A
                bcc _TRUP0

                jsr ERSM0

                lda YM0
                clc
                adc #$05
                cmp #$DF
                bcs _OFFSC0

                sta YM0
                jsr REDRM0

                rts

_TRUP0          jsr ERSM0

                lda YM0
                sec
                sbc #$05
                cmp #$08
                bcc _OFFSC0

                sta YM0
                jsr REDRM0

                rts

_OFFSC1         jsr ERSM0

_OFFSC0         lda #$00
                sta STBUL0
                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
SIDEW0          .proc
                lsr A
                bcc _TRLEF0

                lda XM0
                clc
                adc #$03
                cmp #$CF
                bcs Q70._OFFSC1

                sta XM0
                sta HPOSM0
                rts

_TRLEF0         lda XM0
                sec
                sbc #$03
                cmp #$28
                bcc Q70._OFFSC1

                sta XM0
                sta HPOSM0
                rts
                .endproc


;======================================
;
;======================================
ERSM0           .proc
                ldx #$02
                ldy YM0
_ERLP0          lda MBAS6,Y
                and #$FC
                sta MBAS6,Y
                iny
                dex
                bpl _ERLP0

                rts
                .endproc


;======================================
;
;======================================
REDRM0          .proc
                ldx #$02
                ldy YM0
_REDLP0         lda MBAS6,Y
                ora #$02
                sta MBAS6,Y
                iny
                dex
                bpl _REDLP0

                rts
                .endproc


;======================================
;
;======================================
BUL2            .proc
                lda STBUL2
                bne _W64

                rts

_W64            lda M2PL
                and #$01
                bne _COWHT2

                lda zpXP0
                clc
                adc #$02
                cmp XM2
                bcs _W65

                adc #$03
                cmp XM2
                bcc _W65

                lda zpYP0
                cmp YM2
                bcs _W65

                adc #$0D
                cmp YM2
                bcc _W65

_COWHT2         lda #$00
                sta STBUL2
                jsr ERSM2

                lda STUK0
                bmi _C2RTS

                lda #$80+$3F
                sta STUK0
                lda #$90
                sta DUR1
                lda #$A0
                sta AUD1
_C2RTS          rts

_W65            lda M2PF
                bne _GRA2

                jmp W70

_GRA2           and #$0B
                beq _QB2

                ldx #$02
                stx BHITFL
                jmp HITROU

_QB2            lda YM2
                cmp #$50
                bcs W70

                cmp #$1F
                bcc W70

                lda XM2
                cmp #$48
                bcc _AREA2

                cmp #$B0
                bcc W70

_AREA2          lda STBUL2
                bmi _LFTRT2

                cmp #$01
                beq W70

                jsr WIDEN2

                lda XM2
                cmp #$7C
                bcc _UP2RT2

                lda #$82
                sta STBUL2
                bne BOUNC2

_UP2RT2         lda #$81
                sta STBUL2
                bne BOUNC2

_LFTRT2         lda XM2
                cmp #$7C
                bcc _LEFSD2

                lda STBUL2
                cmp #$81
                beq _BNCDN2

                jmp W70

_LEFSD2         lda STBUL2
                cmp #$82
                beq _BNCDN2

                jmp W70

_BNCDN2         lda #$01
                sta STBUL2
                bne BOUNC2

                .endproc


;--------------------------------------
;
;--------------------------------------
BOUNC2          nop
                nop
                nop


;--------------------------------------
;
;--------------------------------------
W70             .proc
                lda STBUL2
                bmi SIDEW2

                lsr A
                bcc _TRUP2

                jsr ERSM2

                lda YM2
                clc
                adc #$05
                cmp #$DF
                bcs _OFFSC2

                sta YM2
                jsr REDRM2

                rts

_TRUP2          jsr ERSM2

                lda YM2
                sec
                sbc #$05
                cmp #$08
                bcc _OFFSC2

                sta YM2
                jsr REDRM2

                rts

_OFFSC3         jsr ERSM2

_OFFSC2         lda #$00
                sta STBUL2
                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
SIDEW2          .proc
                lsr A
                bcc _TRLEF2

                lda XM2
                clc
                adc #$03
                cmp #$CF
                bcs W70._OFFSC3

                sta XM2
                sta HPOSM2
                rts

_TRLEF2         lda XM2
                sec
                sbc #$03
                cmp #$28
                bcc W70._OFFSC3

                sta XM2
                sta HPOSM2
                rts
                .endproc


;======================================
;
;======================================
ERSM2           .proc
                ldx #$02
                ldy YM2
_ERLP2          lda MBAS6,Y
                and #$CF
                sta MBAS6,Y
                iny
                dex
                bpl _ERLP2

                rts
                .endproc


;======================================
;
;======================================
REDRM2          .proc
                ldx #$02
                ldy YM2
_REDLP2         lda MBAS6,Y
                ora #$20
                sta MBAS6,Y
                iny
                dex
                bpl _REDLP2

                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
HITROU          .proc
                and #$03
                bne _QHR1

                jmp IGNOR

_QHR1           cmp #$03
                bne _QHR2

                jmp IGNOR

_QHR2           and #$01
                eor #$01
                sta HITCOL
                ldy BHITFL              ; TRANSFORM M COOR
                lda XM0,Y
                sec
                sbc #$04                ; OFFSET
                lsr A
                lsr A
                sta XMS
                lda YM0,Y
                sec
                sbc #$08                ; OFFSET
                lsr A
                lsr A
                lsr A
                sta YMS

                ldy #$0F
_TXMCH          lda Z0X,Y
                beq _NXSNKX

                cmp XMS
                beq _CHEKY

_NXSNKX         dey
                bmi _TRYY
                bpl _TXMCH              ; UNC

_CHEKY          lda Z0Y,Y
                sec
                sbc YMS
                beq _TCOLOR

                cmp #$FF
                bne _QHR3

                lda DIRPZ0,Y
                cmp #$01
                beq _TCOLOR
                bne _NXSNKX             ; UNC

_QHR3           cmp #$01
                bne _NXSNKX

                lda DIRPZ0,Y
                cmp #$81
                beq _TCOLOR
                bne _NXSNKX             ; UNC

_TRYY           ldy #$0F
_TYMCH          lda Z0Y,Y
                beq _NXSNKY

                cmp YMS
                beq _CHEKX

_NXSNKY         dey
                bmi _FAIL2F
                bpl _TYMCH              ; UNC

_CHEKX          lda Z0X,Y
                sec
                sbc XMS
                cmp #$FF
                bne _QHR4

                lda DIRPZ0,Y
                cmp #$00
                beq _TCOLOR
                bne _NXSNKY             ; UNC

_QHR4           cmp #$01
                bne _NXSNKY

                lda DIRPZ0,Y
                cmp #$80
                beq _TCOLOR
                bne _NXSNKY             ; UNC

_FAIL2F         jmp IGNOR

_TCOLOR         lda SCRLZ0,Y            ; NOW Y=SNK# HIT
                sta zpSCRL
                lda SCRHZ0,Y
                sta zpSCRH
                lda DIRPZ0,Y
                sta DIRZF
                ldx #$02
                jsr FINDSC

                lda GAMENO
                bne ASBEF

                tax
                lda (zpSCRL,X)          ; HEAD
                nop
                cmp #$2C                ; TUM/SNK
                bcs _TESTUM

                ldx BHITFL
                bne ASBEF

                pha
                jsr QSN1

                ldx #$00
                jsr PLUS

                pla
                clc
                adc #$20
                bne _ENCONV             ; UNC

_TESTUM         ldx BHITFL
                beq ASBEF

                pha
                jsr QSN2

                ldx #$02
                jsr PLUS

                pla
                sec
                sbc #$20
_ENCONV         ldx #$00
                sta (zpSCRL,X)
                beq HITDUN

                .endproc

;--------------------------------------
;--------------------------------------

                .byte $00


;--------------------------------------
;
;--------------------------------------
ASBEF           .proc
                ldx #$02
                lda #$00
                sta (zpSCRL,X)
                lda BHITFL
                lsr A
                clc
                adc #$03
                ldx #$00
                sta (zpSCRL,X)
                nop
                nop
                nop
                lda #$00
                sta Z0X,Y
                dec NUMSNK

                .endproc

                ;[fall-through]


;--------------------------------------
;
;--------------------------------------
HITDUN          .proc
                lda BHITFL
                beq _PL0DUN

                jmp W70._OFFSC3         ; LEAVE BUL2

_PL0DUN         jmp Q70._OFFSC1         ; LEAVE BUL0

                .endproc


;--------------------------------------
;
;--------------------------------------
IGNOR           .proc
                lda BHITFL
                beq _PL0IG

                jmp W70

_PL0IG          jmp Q70

                .endproc


;======================================
;
;======================================
WIDEN0          .proc
                ldy YM0
                lda MBAS6,Y
                ora #$03
                sta MBAS6,Y
                iny
                lda MBAS6,Y
                and #$FC
                sta MBAS6,Y
                iny
                lda MBAS6,Y
                and #$FC
                sta MBAS6,Y
                rts
                .endproc


;======================================
;
;======================================
WIDEN2          .proc
                ldy YM2
                lda MBAS6,Y
                ora #$30
                sta MBAS6,Y
                iny
                lda MBAS6,Y
                and #$CF
                sta MBAS6,Y
                iny
                lda MBAS6,Y
                and #$CF
                sta MBAS6,Y
                rts
                .endproc


;======================================
;
;======================================
QSN1            .proc
                lda #$A0
                sta AUD2
                lda #$50
                sta DUR2
                rts
                .endproc


;======================================
;
;======================================
QSN2            .proc
                lda #$A0
                sta AUD4
                lda #$60
                sta DUR4
                rts
                .endproc


;======================================
;
;======================================
PLUS            .proc
                sed
                lda DIGL0,X             ; 0/2
                clc
                adc #$10
                sta DIGL0,X
                lda DIGH0,X
                adc #$00
                sta DIGH0,X
                cld
                rts
                .endproc

;---
;---

                dex
                bpl $A3F0

                rts

;--------------------------------------

                .byte $A2,$02,$AC
