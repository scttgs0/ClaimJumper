;--------------------------------------
;
;--------------------------------------
START           .proc
                jsr INIT
                jsr COLPF
                jsr COLPM
                jsr CLRPG6

                lda #$FF
                sta CHANC0
                sta CHANC2
                lda #$FF
                sta CRECRI
                lda #$05
                sta EVERY
                jsr CLRSCR
                jsr L9408               ; =CLAIM
_ATRLP          jsr ENDFR
                jsr L940B               ; =COPYRT
                jsr MOVEZZ
                jsr CREATE
                jsr MUSICROU
                jsr STRTES
                jsr OP1TES

                jmp _ATRLP

                .endproc


;======================================
;
;======================================
STRTES          lda #$08
                sta CONSOL
                lda CONSOL
                lsr A
                bcc _STRDB

                lda #$00
                sta STRTFL
                rts

_STRDB          lda STRTFL
                beq _PLSTAT

                rts

_PLSTAT         pla
                pla
                lda #$01
                sta STRTFL
                sta HPOSM1
                lda #$3E
                sta zpXP0
                lda #$B8
                sta zpXP2
                lda #$A0
                sta zpYP0
                sta zpYP2
                jsr CLRPG6

                lda #$3F
                sta CHANC0
                sta CHANC2
                jsr MODE4
LA899           jsr CLRSCR
                jsr RDRSCR
                jsr COLPF
                jsr COLPM
                jsr HOSPIT
                jsr ENDFR

                sta HITCLR
                lda GAMENO
                beq _SS0

                jmp GAME1
_SS0            jmp GAME0


;======================================
;
;======================================
OP0TES          .proc
                ldx #$00
                beq OPTES

                .endproc


;======================================
;
;======================================
OP1TES          ldx #$01

OPTES           lda #$08
                sta CONSOL
                lda CONSOL
                lsr A
                lsr A
                lsr A
                bcc _OPDB

                lda #$00
                sta OPTFL
                clc
                sta zpSCRL+2
                ldx #$A4
                stx zpSCRH+2
                tay
_next1          adc (zpSCRL+2),Y
                iny
                bne _next1

                cmp #$01
                bne LA899+2

                rts

_OPDB           lda OPTFL
                beq _PLOP

                rts

_PLOP           pla
                pla
                lda #$01
                sta OPTFL
                sta HPOSM1
                txa
                bne _OPT1

                jsr DROPT
_BOPT0          jsr ENDFR
                jsr POLL0
                jsr DRTITL
                jsr STRTES
                jsr OP1TES
                jsr SOUND

                jmp _BOPT0

_OPT1           jsr DROPT2
                jsr DRTITL
_BOPT1          jsr ENDFR
                jsr SOUND
                jsr POLL1
                jsr STRTES
                jsr OP0TES

                jmp _BOPT1


;--------------------------------------
;
;--------------------------------------
GAME0           .proc
                lda #$05
                sta EVERY
                lda #$FF
                sta CANCRI
                lda #$08
                sta CRECRI

                jsr DRTITL._TITLE0
                jsr FIXOP0
                jsr FIXOP2

                lda BONUS0
                ora BONUS2
                bne _STOROK

                jsr STOHOU_2
_STOROK         jsr STOHOU
                jsr P06BUL

_G0LOOP         lda FRAME
                and #$01
                bne _SECOND

                jsr MOV0

                jmp _FINISH

_SECOND         jsr MOV2
_FINISH         jsr CANROU
                jsr BUL
                jsr MOVEZZ
                jsr CREATE
_LA96B_BAD      jsr SOUND
                jsr STRTES
                jsr OP1TES
                jsr ENTES0
_LA977_BAD      jsr ENDFR

                jmp _G0LOOP

                .endproc


;--------------------------------------
;
;--------------------------------------
GAME1           tax
                lda #$05
                sta EVERY
                lda #$FF
                sta XFREQ
                dex
                beq _DIFSET

                lsr XFREQ
                dec EVERY
_DIFSET         lda #$06
                sta BONUS0
                lda #$FF
                sta CANCRI
                sta zpYP2
                sta CRECRI
                sta CHANC2
                jsr DRTITL
                jsr PLGUYS

_G1LOOP         lda FRAME
                and #$01
                bne _GQ1

                lda RANDOM
                and XFREQ
                bne _ALTF

                tax
                jsr RANDSC

                lda (zpSCRL,X)
                bne _ALTF

                lda #$04
                sta (zpSCRL,X)
                lda #$C0
                sta AUD3
                lda #$10
                sta DUR3
                inc XCOUNT
                lda XCOUNT
                sec
                sbc #$0F
                bne _ALTF

                sta XCOUNT
                lsr XFREQ
_ALTF           jsr MOV0
_GQ1            jsr CANROU
                jsr BUL
                jsr MOVEZZ
                jsr CREATE
                jsr SOUND
                jsr CRECHG
                jsr STRTES
                jsr OP1TES
                jsr ENTES1
                jsr ENDFR

                jmp _G1LOOP


;======================================
; Initialize the Hardware
;======================================
INIT            .proc
                jsr MODE4

                lda #$00
                sta AUDCTL
                lda #$03
                sta SKCTL

                cld
                lda #$3E            ; 1-LINE
                sta SDMCTL

                lda #$08
                sta PMBASE

                lda #$03
                sta GRACTL
                lda #$21
                sta GPRIOR

                lda #$0C
                sta CHBAS

                lda #$E0            ; DLI
                sta VDSLST
                lda #$95
                sta VDSLST+1

                lda #$C0
                sta NMIEN

                lda #$00
                sta SDLSTL
                lda #$08
                sta SDLSTH

                ldx #$07
_BOB            lda _DBYTE,X
                sta OPTST0,X
                dex
                bpl _BOB

                rts

;--------------------------------------

_DBYTE          .byte $00,$00,$00,$10,$03,$3F,$00,$00

                .endproc


;======================================
; Set Playfield Colors
;======================================
COLPF           .proc
                lda #$4A
                sta COLOR0              ; SNAKE
                lda #$26
                sta COLOR1              ; TUMB
                lda #$AA
                sta COLOR2              ; HOSPIT
                lda #$C8
                sta COLOR3              ; BILLS
                lda #$00
                sta COLOR4
                rts
                .endproc


;======================================
; Set Player/Missile Colors
;======================================
COLPM           .proc
                lda #$E6
                sta PCOLR0              ; COWB0
                lda #$3A
                sta PCOLR2              ; COWB2
                lda #$2C
                sta PCOLR1              ; NUGGET
                lda #$28
                sta PCOLR3              ; FACES
                rts
                .endproc


;======================================
; Clear Screen
;======================================
CLRSCR          .proc
                ldy #$00
                tya
_LIN01          sta L1C00,Y
                sta L1D00,Y
                sta L1E00,Y
                sta L1F00,Y
                sta L1BC8,Y
                dey
                bne _LIN01

                rts
                .endproc


;======================================
; Redraw Screen
;======================================
RDRSCR          .proc
                ldy #$40                ; COL0
                ldx #$CD                ; DATA
                stx zpSCDATA
                jsr STCOL

                ldy #$67                ; COL40
                lda #$4E                ; DATA
                sta zpSCDATA
                jsr STCOL

                lda #$07
                ldx #$25
_BOTLP          sta L1FB1,X
                dex
                bpl _BOTLP

                ldx #$3F
_TOPROW         lda LBFD0,X
                sta L1BF0,X
                lda L9800,X             ; HOSPIT
                sta L1C00,X
                dex
                bpl _TOPROW

                .endproc


;======================================
; Erase Player/Missiles
;======================================
ERSPM           .proc
                lda #$00
                tay
_ERPML          sta MBAS6,Y
                sta L0C00,Y
                sta L0D00,Y
                sta L0E00,Y
                sta L0F00,Y
                iny
                bne _ERPML

                rts
                .endproc


;======================================
;
;======================================
STCOL           .proc
                sty zpSCRL
                ldx #$1C
                stx zpSCRH

                ldx #$00
_NXTCL          lda zpSCDATA
                sta (zpSCRL,X)
                lda #$28
                clc
                adc zpSCRL
                sta zpSCRL
                bcc _NXTCL              ; SAME PG.

                inc zpSCRH              ; NEXT PG.
                lda zpSCRH
                and #$E0                ; TEST FOR DONE
                beq _NXTCL

                lda #$00
                sta L1FD8
                rts

_LAB02_BAD      lda #$A3
                sta zpSCRH

                ldy #$00
                sty zpSCRL
                tya
                inc zpSCRH
_next1          eor (zpSCRL),Y
                iny
                bne _next1

                cmp #$5C
                bne ERSPM._ERPML+2

                rts
                .endproc


;======================================
; Draw Title
;======================================
DRTITL          .proc
                ldy GAMENO
                beq _TITLE0

                dey
                beq _TITLE1

                ldy #$CB
                bne _TITLE              ; UNC

                ldy #$0B
                bne _TITLE              ; UNC

_TITLE0         ldy #$17
                bne _TITLE              ; UNC

_TITLE1         ldy #$23
                bne _TITLE              ; UNC

_TITLEA         ldy #$0B
                bne _TITLE              ; UNC

_TITLE6         ldy #$53
_TITLE          ldx #$0B
_QS11           lda L9500,Y
                sta L1FE6,X
                dey
                dex
                bpl _QS11

                rts
                .endproc


;======================================
; Clear Page-6
;======================================
CLRPG6          .proc
                lda #$00
                ldx #$EF                ; F0+ LEAVE
_QP             sta PAGE6_BASE,X
                dex
                bne _QP

                rts
                .endproc


;--------------------------------------
;--------------------------------------
; Start of code
;--------------------------------------
;--------------------------------------

CART_START      ldx #$28
_next1          lda LA7F0,X
                sta LBB80_DLIST,X
                sta FTABLE,X
                lda LBB80_DLIST,X
                sta L0800,X
                dex
                bpl _next1

                jmp START


;======================================
;
;======================================
HOSPIT          .proc
                ldx #$00
_QS9            lda L9800,X
                sta L1C00,X
                dex
                bne _QS9

                lda #$1B
                sta L1D09
                lda #$3E
                sta L1D05
                sta L1D2E
                lda #$78
                sta L1D06

;   copy character set to RAM
                ldy #$A0                ; CharSet @ $96A0
_BOTLIN         lda L9600-1,Y
                sta L1F5F,Y
                dey
                bne _BOTLIN

                ldx #$00
                jsr PLHAUS
                jsr PLHAUS
                jsr PLHAUS

                ldx #$0C
                jsr PLHAUS

                rts
                .endproc

;--------------------------------------

                rts


;======================================
;
;======================================
DROPT           .proc
                jsr CLRSCR
                jsr OP0TEX

                .endproc

                ;[fall-through]


;--------------------------------------
;
;--------------------------------------
DROPT6          .proc
                ldx #$71
                stx SQ01
                stx SQ02
                stx SQ03

                ldx #$78
                ldy GAMENO
                beq _DG0

                dey
                beq _DG1

                stx SQ03
                rts

_DG0            stx SQ01
                rts

_DG1            stx SQ02
                rts
                .endproc


;======================================
;
;======================================
DROPT2          .proc
                jsr CLRSCR
                jsr ERSPM
                jsr MODE2
                jsr OP2TEX

                lda OPTST0
                jsr DOPT0

                lda OPTST2
                jsr DOPT2

                rts
                .endproc


;======================================
;
;======================================
POLL0           .proc
                lda #$08
                sta CONSOL
                lda CONSOL
                lsr A
                lsr A
                bcc _PUSHTC

                lda #$00
                sta SELFLG
                rts

_PUSHTC         lda SELFLG
                beq _ADV0

                rts

_ADV0           lda #$01
                sta SELFLG
                inc GAMENO
                lda GAMENO
                cmp #$03
                bne _GNOK

                lda #$00
                sta GAMENO
_GNOK           jmp DROPT6

                .endproc


;======================================
;
;======================================
CRECHG          .proc
                lda SNKFLG
                bne _CRTS

                lda NUMSNK
                cmp #$0A
                bne _CRTS

                lda #$01
                sta SNKFLG
                ldx #$01
                lda CRECR1-1,X
                sta CRECRI
_CRTS           rts
                .endproc


;======================================
;
;======================================
ENTES0          .proc
                jsr POINTS

                lda SCOR0
                cmp #$0A
                bcs _P0WINS

                lda SCOR2
                cmp #$0A
                bcs _P2WINS

                rts

_P0WINS         ldx #$00
                beq _GOWIN              ; UNC

_P2WINS         ldx #$01
_GOWIN          stx WINNER
                lda #$00
                sta NUMSNK
                sta SCOR0,X
                lda #$1A
                sta WINCNT
                jmp WIN

_ENLOOP         pla
                pla
_next1          jsr ENDFR
                jsr STRTES
                jsr OP1TES
                jsr SOUND

                jmp _next1

                .endproc


;======================================
;
;======================================
ENTES1          .proc
                lda SNKFLG
                beq _STKTS0

                lda NUMSNK
                bne _STKTS0

                jsr DRTITL._TITLE6      ; WIN
                jmp ENTES0._ENLOOP

_STKTS0         lda STNUM0
                beq _SRTS

                cmp #$04
                bcs _SBRK

                tax
                lda #$60
                sta L1FF4,X
                txa
                cmp #$03
                bne _SRTS

                jsr DRTITL._TITLEA      ; LOSE [TITLE5??]
                jmp ENTES0._ENLOOP

_SRTS           rts


;--------------------------------------
_SBRK           brk
;--------------------------------------

                .endproc


;======================================
;
;======================================
PLGUYS          .proc
                ldx #$02
                lda #$7E
_G1             sta L1FF5,X
                dex
                bpl _G1

                rts
                .endproc


;======================================
;
;======================================
POLL1           .proc
                lda FRAME
                and #$03
                beq _POL1OK

                rts

_POL1OK         lda STRIG0
                bne _UNLOK0

                lda TRG0FL
                bne _POLTG1

                lda #$01
                sta TRG0FL
                jsr CHOPT0

_POLTG1         lda STRIG1
                bne _UNLOK1

                lda TRG1FL
                bne _POLRTS

                lda #$01
                sta TRG1FL
                jsr CHOPT2

_POLRTS         rts

_UNLOK0         lda #$00
                sta TRG0FL
                beq _POLTG1             ; UNC

_UNLOK1         lda #$00
                sta TRG1FL
                rts
                .endproc


;======================================
;
;======================================
CHOPT0          .proc
                lda OPTST0
                clc
                adc #$01
                and #$03
                sta OPTST0

                .endproc

                ;[fall-through]

;======================================
;
;======================================
DOPT0           .proc
                clc
                adc #$01
                cmp #$03
                bne _DISP0

                asl A
_DISP0          jsr CHEKNO

                stx SQ1
                jsr CHEKNO

                stx SQ2
                jsr CHEKNO

                stx SQ3
                rts
                .endproc


;======================================
;
;======================================
CHOPT2          .proc
                lda OPTST2
                clc
                adc #$01
                and #$03
                sta OPTST2

                .endproc

                ;[fall-through]


;======================================
;
;======================================
DOPT2           .proc
                clc
                adc #$01
                cmp #$03
                bne _DISP2

                asl A
_DISP2          jsr CHEKNO

                stx SQ4
                jsr CHEKNO

                stx SQ5
                jsr CHEKNO

                stx SQ6
                rts
                .endproc


;======================================
;
;======================================
CHEKNO          .proc
                lsr A
                bcs _CH

                ldx #$71                ; NOCHK
                rts

_CH             ldx #$78                ; CHK
                rts
                .endproc


;======================================
;
;======================================
FIXOP0          .proc
                ldx OPTST0
                beq _NOBON0

                dex
                beq _EX6BL0

                dex
                bne _F03

                jsr HEAD0

_EX6BL0         lda #$06
                sta BONUS0
                inc GAME0._LA96B_BAD
                rts

_F03            jsr HEAD0

_NOBON0         ldx #$00
                stx BONUS0
                rts
                .endproc


;======================================
;
;======================================
HEAD0           .proc
                ldx #$05
                stx SCOR0
                lda #$88
_HDLP0          sta L1FB3,X
                dex
                bne _HDLP0

                lda #$FF
                sta XFREQ
                lda #$05
                sta EVERY
                rts
                .endproc


;======================================
;
;======================================
FIXOP2          .proc
                ldx OPTST2
                beq _NOBON2

                dex
                beq _EX6BL2

                dex
                bne _F23

                jsr HEAD2

_EX6BL2         lda #$06
                sta BONUS2
                inc GAME0._LA977_BAD
                rts

_F23            jsr HEAD2

_NOBON2         ldx #$00
                stx BONUS2
                rts
                .endproc


;======================================
;
;======================================
HEAD2           .proc
                ldx #$05
                stx SCOR2
                lda #$9F
_HDLP2          sta L1FCE,X
                dex
                bne _HDLP2

                rts
                .endproc


;======================================
;
;======================================
MODE2           .proc
                lda #$94
                sta CHBAS
                ldx #$0A
                ldy #$50
                lda #$02
                bne MODE4._CHDL

                .endproc


;======================================
;
;======================================
MODE4           .proc
                lda #$B0
                sta CHBAS
                ldx #$26                ; BROWN
                ldy #$AA                ; BLUE
                lda #$04
_CHDL           stx COLOR1
                sty COLOR2

                ldx #$16
_CHDLP          sta L0804,X             ; DLIST+4
                dex
                bne _CHDLP

                rts
                .endproc


;======================================
;
;======================================
OP0TEX          .proc
                ldx #$0B
_TXT0LP         lda L953C,X
                sta L1D17,X
                lda L950C,X
                sta L1DB8,X
                lda L9518,X
                sta L1E30,X
                lda L95C0,X
                sta L1EA8,X
                dex
                bpl _TXT0LP

                rts
                .endproc


;======================================
;
;======================================
OP2TEX          .proc
                ldx #$0B
_TXT2LP         lda L9524,X
                sta L1D11,X
                lda L9530,X
                sta L1D1D,X
                lda L9554,X
                sta L1DAE,X
                sta L1DC1,X
                lda L9560,X
                sta L1E26,X
                sta L1E39,X
                lda L956C,X
                sta L1E9E,X
                sta L1EB1,X
                dex
                bpl _TXT2LP

                rts
                .endproc

;--------------------------------------
BUG             brk
;--------------------------------------


;======================================
;
;======================================
PLHAUS          .proc
                lda #$00
                sta TEST
_FNLP           inc TEST
                beq BUG

                lda RANDOM
                and #$07
                tay
                lda CACPOS,Y
                sta zpSCRL
                clc
                adc #$03
                sta zpSCRL+4
                lda CACPOS+8,Y
                sta zpSCRH
                sta zpSCRH+4

                ldy #$02
_LP1            lda (zpSCRL),Y
                cmp #$05
                bcs _FNLP

                dey
                bpl _LP1

                ldy #$02
_TOP3           dec zpSCRL+4
                jsr TESTX

                lda HSBAS,X
                sta (zpSCRL),Y
                inx
                dey
                bpl _TOP3

                lda #$28
                clc
                adc zpSCRL
                sta zpSCRL
                bcc _HIOK

                inc zpSCRH
                inc zpSCRH+4
_HIOK           clc
                adc #$03
                sta zpSCRL+4
                ldy #$02
_BOT3           dec zpSCRL+4
                jsr TESTX

                lda HSBAS,X
                sta (zpSCRL),Y
                inx
                dey
                bpl _BOT3

                lda #$C0
                sta NoteAttack
                lda #$07
                sta MCNT4
                lda #$FF
                sta FRAMM
                rts
                .endproc


;======================================
;
;======================================
TESTX           .proc
                lda (zpSCRL),Y
                cmp #$01
                bne _TEST2

                txa
                pha
                tya
                pha
                jsr SMASH0

                pla
                tay
                pla
                tax
                dec NUMBT0
                rts

_TEST2          cmp #$02
                bne _TEST3

                txa
                pha
                tya
                pha
                jsr SMASH2

                pla
                tay
                pla
                tax
                dec NUMBT2
_XRTS           rts

_TEST3          cmp #$05
                bcc _XRTS

                lda #$00                ; ON EGG
                sta EGGP                ; =EGGP
                rts
                .endproc


;--------------------------------------
;--------------------------------------
BUYHOU          clc
                sed
                ldx WINNER
                beq _P0BUY

                lda DIGH2
                adc #$20
                adc ADPNT0+6
                sta DIGH2
                ldx #$06
                bne _GOBUY

_P0BUY          lda DIGH0
                adc #$20
                adc ADPNT0
                sta DIGH0
_GOBUY          cld
                lda #$30
                sta ADPNT0,X
                jsr PLHAUS

                dec EVERY
                lda EVERY
                cmp #$03
                bne _GRTS

                lda #$06
                sta L0668               ; SUBSNK
_GRTS           rts


;--------------------------------------
;
;--------------------------------------
WIN             ldx #$06
                lda #$00
_QULOP          sta AUDC1,X
                dex
                bpl _QULOP

_WINLOP         jsr ENDFR

                lda FRAME
                and #$07
                beq _REMOVE

                cmp #$04
                bne _WINLOP

                lda #$00
                sta AUDC4
                beq _WINLOP

_REMOVE         dec WINCNT
                lda WINCNT
                bmi BUYHOU

                cmp #$10
                bcs _REMSNK             ; BAGE

                cmp #$0A
                bcs _WINLOP

                nop
                ldx WINNER
                bne _P2BIL

                tay
                lda #$07
                sta L1FB4,Y
_SNBANG         lda #$88
                sta AUDC4
                lda #$20
                sta AUDF4
                bne _WINLOP

_P2BIL          eor #$0F
                tay
                lda #$07
                sta L1FC4,Y
                bne _SNBANG

_REMSNK         nop
                and #$0F
                tax
                lda Z0X,X
                beq _WINLOP

                lda #$00
                sta Z0X,X
                lda SCRLZ0,X
                sta zpSCRL
                lda SCRHZ0,X
                sta zpSCRH
                lda DIRPZ0,X
                ldx #$02
                sta DIRZF
                jsr FINDSC

                lda #$00
                tax
                sta (zpSCRL,X)
LAF55           sta (zpSCRL+2,X)
                jmp WIN._SNBANG


;======================================
;
;======================================
STOHOU_2        .proc
                ldx #$03
_TPST           lda L99F2,X
                sta L1F9A,X
                lda L99F6,X
                sta L1FC2,X
                dex
                bpl _TPST

                rts
                .endproc
