
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
                bne _1

                rts

_1              lda M0PL
                and #$04
                bne _2

                lda zpXP2
                clc
                adc #$02
                cmp XM0
                bcs _4

                adc #$03
                cmp XM0
                bcc _4

                lda zpYP2
                cmp YM0
                bcs _4

                adc #$0D
                cmp YM0
                bcc _4

_2              lda #$00
                sta STBUL0
                jsr ERSM0

                lda STUK2
                bmi _3

                lda #$80+$3F
                sta STUK2
                lda #$90
                sta DUR3
                lda #$A0
                sta AUD3
_3              rts

_4              lda M0PF
                bne _5

                jmp Q70

_5              and #$0B
                beq _6

                ldx #$00
                stx BHITFL
                jmp HITROU

_6              lda YM0
                cmp #$50
                bcs Q70

                cmp #$1F
                bcc Q70

                lda XM0
                cmp #$48
                bcc _7

                cmp #$B0
                bcc Q70

_7              lda STBUL0
                bmi _9

                cmp #$01
                beq Q70

                jsr WIDEN0

                lda XM0
                cmp #$7C
                bcc _8

                lda #$82
                sta STBUL0
                bne BOUNC0

_8              lda #$81
                sta STBUL0
                bne BOUNC0

_9              lda XM0
                cmp #$7C
                bcc _10

                lda STBUL0
                cmp #$81
                beq _11

                jmp Q70

_10             lda STBUL0
                cmp #$82
                beq _11

                jmp Q70

_11             lda #$01
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
                bcc _1

                jsr ERSM0

                lda YM0
                clc
                adc #$05
                cmp #$DF
                bcs _2

                sta YM0
                jsr REDRM0

                rts

_1              jsr ERSM0

                lda YM0
                sec
                sbc #$05
                cmp #$08
                bcc _2

                sta YM0
                jsr REDRM0

                rts

_OFFSC1         jsr ERSM0

_2              lda #$00
                sta STBUL0
                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
SIDEW0          .proc
                lsr A
                bcc _1

                lda XM0
                clc
                adc #$03
                cmp #$CF
                bcs Q70._OFFSC1

                sta XM0
                sta HPOSM0
                rts

_1              lda XM0
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
_next1          lda MBAS6,Y
                and #$FC
                sta MBAS6,Y

                iny
                dex
                bpl _next1

                rts
                .endproc


;======================================
;
;======================================
REDRM0          .proc
                ldx #$02
                ldy YM0
_next1          lda MBAS6,Y
                ora #$02
                sta MBAS6,Y

                iny
                dex
                bpl _next1

                rts
                .endproc


;======================================
;
;======================================
BUL2            .proc
                lda STBUL2
                bne _1

                rts

_1              lda M2PL
                and #$01
                bne _2

                lda zpXP0
                clc
                adc #$02
                cmp XM2
                bcs _3

                adc #$03
                cmp XM2
                bcc _3

                lda zpYP0
                cmp YM2
                bcs _3

                adc #$0D
                cmp YM2
                bcc _3

_2              lda #$00
                sta STBUL2
                jsr ERSM2

                lda STUK0
                bmi _XIT1

                lda #$80+$3F
                sta STUK0
                lda #$90
                sta DUR1
                lda #$A0
                sta AUD1

_XIT1           rts

_3              lda M2PF
                bne _4

                jmp W70

_4              and #$0B
                beq _5

                ldx #$02
                stx BHITFL
                jmp HITROU

_5              lda YM2
                cmp #$50
                bcs W70

                cmp #$1F
                bcc W70

                lda XM2
                cmp #$48
                bcc _6

                cmp #$B0
                bcc W70

_6              lda STBUL2
                bmi _8

                cmp #$01
                beq W70

                jsr WIDEN2

                lda XM2
                cmp #$7C
                bcc _7

                lda #$82
                sta STBUL2
                bne BOUNC2

_7              lda #$81
                sta STBUL2
                bne BOUNC2

_8              lda XM2
                cmp #$7C
                bcc _9

                lda STBUL2
                cmp #$81
                beq _10

                jmp W70

_9              lda STBUL2
                cmp #$82
                beq _10

                jmp W70

_10             lda #$01
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
                bcc _1

                jsr ERSM2

                lda YM2
                clc
                adc #$05
                cmp #$DF
                bcs _2

                sta YM2
                jsr REDRM2

                rts

_1              jsr ERSM2

                lda YM2
                sec
                sbc #$05
                cmp #$08
                bcc _2

                sta YM2
                jsr REDRM2

                rts

_OFFSC3         jsr ERSM2

_2              lda #$00
                sta STBUL2
                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
SIDEW2          .proc
                lsr A
                bcc _1

                lda XM2
                clc
                adc #$03
                cmp #$CF
                bcs W70._OFFSC3

                sta XM2
                sta HPOSM2
                rts

_1              lda XM2
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
_next1          lda MBAS6,Y
                and #$CF
                sta MBAS6,Y

                iny
                dex
                bpl _next1

                rts
                .endproc


;======================================
;
;======================================
REDRM2          .proc
                ldx #$02
                ldy YM2
_next1          lda MBAS6,Y
                ora #$20
                sta MBAS6,Y

                iny
                dex
                bpl _next1

                rts
                .endproc


;--------------------------------------
;
;--------------------------------------
HITROU          .proc
                and #$03
                bne _1

                jmp IGNOR

_1              cmp #$03
                bne _2

                jmp IGNOR

_2              and #$01
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
_next1          lda Z0X,Y
                beq _next2

                cmp XMS
                beq _3

_next2          dey
                bmi _TRYY
                bpl _next1              ; UNC

_3              lda Z0Y,Y
                sec
                sbc YMS
                beq _TCOLOR

                cmp #$FF
                bne _4

                lda DIRPZ0,Y
                cmp #$01
                beq _TCOLOR
                bne _next2             ; UNC

_4              cmp #$01
                bne _next2

                lda DIRPZ0,Y
                cmp #$81
                beq _TCOLOR
                bne _next2             ; UNC

_TRYY           ldy #$0F
_next3          lda Z0Y,Y
                beq _next4

                cmp YMS
                beq _CHEKX

_next4          dey
                bmi _6
                bpl _next3              ; UNC

_CHEKX          lda Z0X,Y
                sec
                sbc XMS
                cmp #$FF
                bne _5

                lda DIRPZ0,Y
                cmp #$00
                beq _TCOLOR
                bne _next4             ; UNC

_5              cmp #$01
                bne _next4

                lda DIRPZ0,Y
                cmp #$80
                beq _TCOLOR
                bne _next4             ; UNC

_6              jmp IGNOR

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
                bne _7                  ; UNC

_TESTUM         ldx BHITFL
                beq ASBEF

                pha
                jsr QSN2

                ldx #$02
                jsr PLUS

                pla
                sec
                sbc #$20
_7              ldx #$00
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
                beq _1

                jmp W70._OFFSC3         ; LEAVE BUL2

_1              jmp Q70._OFFSC1         ; LEAVE BUL0

                .endproc


;--------------------------------------
;
;--------------------------------------
IGNOR           .proc
                lda BHITFL
                beq _1

                jmp W70

_1              jmp Q70

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
