
;======================================
;
;======================================
MOV0            lda #$0C                ; P0BAS
                sta zpYBAS
                lda zpYP0
                sta zpYP
                lda zpXP0
                sta zpXP
                jsr ERASE

                lda STUK0
                bne _JJST0

                lda STRIG0
                beq _PUSHT0

                lda #$00
                sta TRG0FL
_JJST0          jmp _ST0

_PUSHT0         lda TRG0FL
                bne _JJST0

                lda #$01
                sta TRG0FL
                lda STATCN
                cmp #$80
                beq _JST0

                jsr EDGE

                cmp #$0F
                beq _Q61

                ldx STBUL0
                bne _NODRP0             ; BUL OUT

                ldx NUMBL0
                beq _NODRP0             ; NOMORBL

                cmp #$0E
                bne _Q02

                ldx #$02                ; UP
                bne _CORDM0             ; UNC

_Q02            cmp #$0D
                bne _Q03

                ldx #$01                ; DOWN
                bne _CORDM0             ; UNC

_Q03            and #$04
                bne _Q04

                ldx #$82                ; LEFT
                bne _CORDM0             ; UNC

_Q04            ldx #$81                ; RIGHT
_CORDM0         lda STUK0
                bne _NODRP0             ; STUK

                lda P0PF
                and #$04                ; P0PF2
                beq _SHOOT0

                lda zpXP0
                cmp #$49
                bcc _NODRP0             ; LFTHOSP

                cmp #$AD
                bcs _NODRP0             ; RTHOSP

_SHOOT0         stx STBUL0
                lda BONUS0
                beq _BOK0

                dec NUMBL0
                jsr SCDEC0

_BOK0           lda zpYP0
                clc
                adc #$09
                sta YM0
                and #$07
                cmp #$07
                bne _NPH0

                inc YM0
_NPH0           lda zpXP0
                adc #$07
                sta XM0
                sta HPOSM0
                jsr WIDEN0
                jsr SN2V1

_JST0           jmp _ST0

_NODRP0         jmp _NDRP0

_Q61            jsr XPYPSC

                ldy #$00
                lda (zpSCRL),Y
                bne _NDRP0              ; OCCUP

                lda zpSCRL
                cmp #$87
                bcc _QM0

                lda zpSCRH
                cmp #$1F
                beq _NDRP0              ; BOT

_QM0            jsr SN1V1

                lda #$01
                sta (zpSCRL),Y
                inc NUMBT0
                lda NUMBT0
                cmp #$07
                bne _SIX0

                dec NUMBT0
                ldx #$00
                jsr COMPR

_SIX0           ldx NUMBT0
                lda zpSCRL
                sta L06C0,X
                lda zpSCRH
                sta L06C8,X
                bne _ST0

_NDRP0          jsr SNBPV1

_ST0            lda STUK0
                beq _COLL0

                dec STUK0
                beq _Q66

                cmp #$80
                bne _Q20

                lda #$20
                sta STUK0
                jsr DOCT0

                jmp _Q25

_Q66            lda #$3F                ; UNSTUK
                sta CHANC0
                lda #$1E
                sta IMMUN0
_Q20            lda STUK0
                bpl _QX20

                jsr DRHIT

                jmp _BACK2

_QX20           jsr DRSTUK

                jmp _BACK2

_COLL0          lda P0PF
                and #$01
                beq _Q28

                lda IMMUN0
                bne _Q21

                lda #$3F                ; 2-SEC PENAL
                sta STUK0
                lda #$01
                sta TRG0FL
                lda #$FF
                sta CHANC0
                inc STNUM0

                jsr SN3V1               ; FROZ
                jsr DRSTUK

                jmp _BACK2

_Q21            cmp #$1E
                beq _Q22

                dec IMMUN0
_Q22            jmp _STMOV0

_Q28            lda IMMUN0
                beq _STMOV0

                dec IMMUN0
_STMOV0         lda STICK0
                sta STSHFT
                jsr UPDTXY

_Q25            lda zpYP
                sta zpYP0
                lda zpXP
                sta zpXP0
                sta HPOSP0
                clc
                adc #$04
                sta HPOSM3
                jsr DRMVNG

_BACK2          rts


;======================================
;
;======================================
DRHIT           .proc
                lda FRAME
                and #$04
                beq _DHIT

                rts

_DHIT           ldx #$7F
                bne DRMVNG._DRW         ; UNC

                .endproc


;======================================
;
;======================================
DRSTUK          .proc
                lda FRAME
                and #$04
                beq _DRNOMV

                rts

_DRNOMV         ldx #$0F
                bne DRMVNG._DRW         ; UNC

                .endproc


;======================================
;
;======================================
EDGE            .proc
                ldy #$00
                lda zpYBAS
                cmp #$0C                ; =PL0
                beq _Q55

                iny
_Q55            lda STICK0,Y            ; STIK0 OR 1
                sta STSHFT
                lda zpXP
                cmp #$C6
                bne _QUP2

                lda STSHFT
                ora #$08
                sta STSHFT
                bne _QUP3

_QUP2           cmp #$30
                bne _QUP3

                lda STSHFT
                ora #$04
                sta STSHFT
_QUP3           lda STSHFT
                rts
                .endproc


;======================================
;
;======================================
DRMVNG          .proc
                jsr EDGE

                eor #$0F
                beq DRSTUK._DRNOMV

                cmp #$01
                beq _UPORDN

                cmp #$02
                beq _UPORDN

                ror STSHFT              ; MOVE
                ror STSHFT              ; LFT OR RGT
                ldx #$3F
                lda zpXP
                and #$02
                beq _Q53

                jsr PITPAT

                ldx #$4F
_Q53            ror STSHFT
                bcc _DRW

                txa
                clc
                adc #$20
                tax
_DRW            ldy #$0F
_Q54            lda LB500,X
                sta (zpYP),Y
                dex
                dey
                bpl _Q54

                txa
                clc
                adc #$10
                tax
                ldy #$0F
                lda zpYBAS
                cmp #$0C
                bne _DRP3

                dec zpYBAS              ; P0 TO M
_DRM3LP         lda (zpYP),Y
                ora FLESH,X
                sta (zpYP),Y
                dex
                dey
                bpl _DRM3LP

                inc zpYBAS
                rts

_DRP3           inc zpYBAS              ; P2 TO P3
_DRP3LP         lda FLESH,X
                sta (zpYP),Y
                dex
                dey
                bpl _DRP3LP

                dec zpYBAS
                rts

_UPORDN         ldx #$1F
                lda zpYP
                and #$02
                bne _DRW

                jsr PITPAT

                ldx #$2F
                jmp _DRW

                .endproc


;======================================
;
;======================================
MOV2            lda #$0E
                sta zpYBAS
                lda zpYP2
                sta zpYP
                lda zpXP2
                sta zpXP
                jsr ERASE

                lda STUK2
                bne _JJST2

                lda STRIG1
                beq _PUSHT2

                lda #$00
                sta TRG1FL
_JJST2          jmp _ST2

_PUSHT2         lda TRG1FL
                bne _JJST2

                lda #$01
                sta TRG1FL
                lda STATCN
                cmp #$81
                beq _JST2

                jsr EDGE

                cmp #$0F
                beq _W61

                ldx STBUL2
                bne _NODRP2             ; BULOUT

                ldx NUMBL2
                beq _NODRP2             ; OUTOFBL

                cmp #$0E
                bne _W02

                ldx #$02                ; UP
                bne _CORDM2             ; UNC

_W02            cmp #$0D
                bne _W03

                ldx #$01                ; DOWN
                bne _CORDM2             ; UNC

_W03            and #$04
                bne _W04

                ldx #$82                ; LEFT
                bne _CORDM2             ; UNC

_W04            ldx #$81                ; RIGHT
_CORDM2         lda STUK2
                bne _NODRP2             ; STUK

                lda P2PF
                and #$04
                beq _SHOOT2

                lda zpXP2
                cmp #$49
                bcc _NODRP2             ; LFTHOS

                cmp #$AD
                bcs _NODRP2             ; RTHOSP

_SHOOT2         stx STBUL2
                lda BONUS2
                beq _BOK2

                dec NUMBL2
                jsr SCDEC2

_BOK2           lda zpYP2
                clc
                adc #$09
                sta YM2
                and #$07
                cmp #$07
                bne _NPH2

                inc YM2
_NPH2           lda zpXP2
                adc #$02
                sta XM2
                sta HPOSM2
                jsr WIDEN2
                jsr SN2V3

_JST2           jmp _ST2

_NODRP2         jmp _NDRP2

_W61            jsr XPYPSC

                ldy #$00
                lda (zpSCRL),Y
                bne _NDRP2              ; OCCUP

                lda zpSCRL
                cmp #$87
                bcc _WM0

                lda zpSCRH
                cmp #$1F
                beq _NDRP2              ; BOT

_WM0            jsr SN1V3

                lda #$02
                sta (zpSCRL),Y
                inc NUMBT2
                lda NUMBT2
                cmp #$07
                bne _SIX2

                dec NUMBT2
                ldx #$10
                jsr COMPR

_SIX2           ldx NUMBT2
                lda zpSCRL
                sta L06D0,X
                lda zpSCRH
                sta L06D8,X
                bne _ST2                ; UNC

_NDRP2          jsr SNBPV3

_ST2            lda STUK2
                beq _COLL2

                dec STUK2
                beq _W66

                cmp #$80
                bne _W20

                lda #$20
                sta STUK2
                jsr DOCT2

                jmp _W25

_W66            lda #$3F                ; UNSTUK
                sta CHANC2
                lda #$1E
                sta IMMUN2
_W20            lda STUK2
                bpl _WX20

                jsr DRHIT

                jmp _SQRDUN

_WX20           jsr DRSTUK

                jmp _SQRDUN

_COLL2          lda P2PF
                and #$02
                beq _W28

                lda IMMUN2
                bne _W21

                lda #$3F
                sta STUK2
                lda #$01
                sta TRG1FL
                lda #$FF
                sta CHANC2
                inc STNUM2

                jsr SN4V3               ; FROZ
                jsr DRSTUK

                jmp _SQRDUN

_W21            cmp #$1E
                beq _W22

                dec IMMUN2
_W22            jmp _STMOV2

_W28            lda IMMUN2
                beq _STMOV2

                dec IMMUN2
_STMOV2         lda STICK1
                sta STSHFT
                jsr UPDTXY

_W25            lda zpYP
                sta zpYP2
                lda zpXP
                sta zpXP2
                sta HPOSP2
                clc
                adc #$04
                sta HPOSP3
                jsr DRMVNG

_SQRDUN         rts


;======================================
;
;======================================
DOCT0           .proc
                lda STICK0
                bne DOCT2._DOCTX

                .endproc

                ;[fall-through]


;======================================
;
;======================================
DOCT2           .proc
                lda STICK1
_DOCTX          and #$0C
                cmp #$0C
                beq _RANDOC

                cmp #$04
                beq _RTDOC

_LFDOC          lda #$35
                sta zpXP
                bne _DOCDUN             ; UNC

_RTDOC          lda #$C1
                sta zpXP
_DOCDUN         lda #$29
                sta zpYP
                rts

_RANDOC         lda RANDOM
                bmi _RTDOC
                bpl _LFDOC              ; UNC

                .endproc


;======================================
;
;======================================
MOVEZZ          inc GROUP
                lda GROUP
                cmp EVERY
                bcs _GRP0

                cmp #$04
                bcc _GRPOK

                rts

_GRP0           lda #$00
                sta GROUP
_GRPOK          asl A
                asl A
                tay
_Q16            lda Z0X,Y
                beq _NEXTZ

                sta ZX_
                lda Z0Y,Y
                sta ZY_
                lda DIRPZ0,Y
                sta DIRP
                sty SAVEZ
                lda SCRLZ0,Y
                sta zpSCRL
                lda SCRHZ0,Y
                sta zpSCRH
                jsr SMOOTH

                ldy SAVEZ
_NEXTZ          iny
                tya
                and #$03
                bne _Q16

                rts


;======================================
;
;======================================
SCDEC0          .proc
                lda #$00
                ldx NUMBL0
                sta ScreenFooter+4,X
                rts
                .endproc


;======================================
;
;======================================
SCDEC2          .proc
                lda #$0A
                sec
                sbc NUMBL2
                tax
                lda #$00
                sta ScreenFooter+25,X
                rts
                .endproc


;======================================
;
;======================================
XPYPSC          .proc
                lda zpXP
                lsr A
                lsr A
                tax
                lda zpYP
                lsr A
                lsr A
                lsr A
                tay
                tya
                sec
                sbc #$02
                tay
                lda #$1C
                sta zpSCRH
                txa
                clc
                adc #$0D
_ADD40B         adc #$28
                bcc _X3

                inc zpSCRH
                clc
_X3             dey
                bne _ADD40B

                sta zpSCRL
                rts
                .endproc


;======================================
;
;======================================
ERASE           .proc
                ldy #$0F
                lda #$00
_ERSLIN         sta (zpYP),Y
                dey
                bpl _ERSLIN

                ldy #$0F
                lda zpYBAS
                cmp #$0C
                bne _ERSP3

                dec zpYBAS              ; P2 TO M3
_ERM3LP         lda (zpYP),Y
                and #$3F
                sta (zpYP),Y
                dey
                bpl _ERM3LP

                inc zpYBAS
                rts

_ERSP3          inc zpYBAS              ; P2 TO P3
                lda #$00
_ERP3LP         sta (zpYP),Y
                dey
                bpl _ERP3LP

                dec zpYBAS
                rts
                .endproc


;======================================
;
;======================================
UPDTXY          .proc
                ror STSHFT
                bcs _BACK

                ldx zpYP
                dex
                cpx #$1A
                bcs _EDJOKT

                inx
_EDJOKT         stx zpYP
_BACK           ror STSHFT
                bcs _LEFT

                ldx zpYP
                inx
                cpx #$C8
                bcc _EDJOKB

                dex
_EDJOKB         stx zpYP
_LEFT           ror STSHFT
                bcs _RIGHT

                ldx zpXP
                dex
                cpx #$30
                bcs _EDJOKL

                inx
_EDJOKL         stx zpXP
_RIGHT          ror STSHFT
                bcs _UPDONE

                ldx zpXP
                inx
                cpx #$C7
                bcc _EDJOKR

                dex
_EDJOKR         stx zpXP
_UPDONE         rts

                .endproc

JMOV2           jmp MOV2
JMOVZ           jmp MOVEZZ


;======================================
;
;======================================
PITPAT          .proc
                lda FRAME
                and #$01
                bne _PL2PIT

                lda DUR1
                beq _PIT0

                rts

_PIT0           lda #$00
                sta AUD1
                lda #$0E
                sta DUR1
                lda #$32
                sta SMOOTH
                rts

_PL2PIT         lda DUR3
                beq _PIT2

                rts

_PIT2           lda #$20
                sta AUD3
                lda #$0E
                sta DUR3
                lda #$42
                sta SMOOTH
                rts
                .endproc


;======================================
; Sound-1, Voice-1
;======================================
SN1V1           .proc
                lda #$A0                ; PL0 FART
                sta AUD1
                lda #$40
                sta DUR1
                rts
                .endproc


;======================================
; Sound-1, Voice-3
;======================================
SN1V3           .proc
                lda #$C0                ; PL2 FART
                sta AUD3
                lda #$10
                sta DUR3
                rts
                .endproc


;======================================
; Sound-2, Voice-1
;======================================
SN2V1           .proc
                lda #$80
                sta AUD1
                lda #$20
                sta DUR1
                rts
                .endproc


;======================================
; Sound-2, Voice-3
;======================================
SN2V3           .proc
                lda #$80
                sta AUD3
                lda #$20
                sta DUR3
                rts
                .endproc


;======================================
; Sound-3, Voice-1
;======================================
SN3V1           .proc
                lda #$20                ; PL0 FROZ
                sta AUD1
                lda #$30
                sta DUR1
                rts
                .endproc


;======================================
; Sound-4, Voice-3
;======================================
SN4V3           lda #$C0                ; PL2 BZ
                sta AUD3
                lda #$30
                sta DUR3
                rts


;======================================
; Sound-BP, Voice-1
;======================================
SNBPV1          .proc
                lda #$A0                ; BUTBEEP
                sta AUD1
                lda #$80
                sta DUR1
                rts
                .endproc


;======================================
; Sound-BP, Voice-3
;======================================
SNBPV3          .proc
                lda #$A0
                sta AUD3
                lda #$80
                sta DUR3
                rts
                .endproc


;======================================
;
;======================================
COMPR           .proc
                ldy #$00                ; X=0 OR $10
                lda L06C1,X
                sta zpSCRL+2
                lda L06C9,X
                sta zpSCRH+2
                lda #$00
                sta (zpSCRL+2),Y

                ldy #$06
_COMLP          lda L06C2,X
                sta L06C1,X
                lda L06CA,X
                sta L06C9,X
                inx
                dey
                bne _COMLP

_XIT            rts

                sta L06C9,X
                inx
                dey
                bne $BB5B

                rts

                sta L06C9,X
                inx
                dey
                bne _XIT

                rts
                .endproc

;--------------------------------------
;--------------------------------------

                .fill 12,$00
