
TitleGlyphs     .byte $03,$0F,$3F,$3F,$3C,$3C,$3C,$3C   ; [C]
                .byte $F0,$FC,$FF,$0F,$00,$00,$00,$00
                .byte $3C,$3C,$3C,$3C,$3F,$3F,$0F,$03
                .byte $00,$00,$00,$00,$0F,$FF,$FC,$F0
                ; ...C CC..
                ; ..CC CCC.
                ; .CCC CCCC
                ; .CCC ..CC
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....

                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CCC ..CC
                ; .CCC CCCC
                ; ..CC CCC.
                ; ...C CC..

                .byte $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C   ; [L]
                .byte $3C,$3C,$3C,$3C,$3C,$3F,$3F,$3F
                .byte $00,$00,$00,$00,$00,$FF,$FF,$FF
                ; .CC.
                ; .CC.
                ; .CC.
                ; .CC.
                ; .CC.
                ; .CC.
                ; .CC.
                ; .CC.
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CCC CCCC
                ; .CCC CCCC
                ; .CCC CCCC

                .byte $03,$03,$0F,$0F,$3F,$3C,$FC,$F0   ; [A]
                .byte $C0,$C0,$F0,$F0,$FC,$3C,$3F,$0F
                .byte $F0,$F0,$FF,$FF,$F0,$F0,$F0,$F0
                .byte $0F,$0F,$FF,$FF,$0F,$0F,$0F,$0F
                ; ...C C...
                ; ...C C...
                ; ..CC CC..
                ; ..CC CC..
                ; .CCC CCC.
                ; .CC. .CC.
                ; CCC. .CCC
                ; CC.. ..CC

                ; CC.. ..CC
                ; CC.. ..CC
                ; CCCC CCCC
                ; CCCC CCCC
                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC


                .byte $F0,$F0,$FC,$FC,$FF,$FF,$FF,$F3   ; [M]
                .byte $0F,$0F,$3F,$3F,$FF,$FF,$FF,$CF
                .byte $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
                .byte $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
                ; CC.. ..CC
                ; CC.. ..CC
                ; CCC. .CCC
                ; CCC. .CCC
                ; CCCC CCCC
                ; CCCC CCCC
                ; CCCC CCCC
                ; CC.C C.CC

                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC
                ; CC.. ..CC

                .byte $00,$00,$00,$00,$3F,$3F,$0F,$03   ; [J - bottom]
                .byte $0F,$0F,$0F,$0F,$3F,$FF,$FC,$F0
                ; .... ..CC
                ; .... ..CC
                ; .... ..CC
                ; .... ..CC
                ; .CCC .CCC
                ; .CCC CCCC
                ; ..CC CCC.
                ; ...C CC..

                .byte $3F,$3F,$3F,$3C,$3C,$3C,$3C,$3F   ; [P]
                .byte $F0,$FC,$FF,$3F,$0F,$0F,$3F,$FF
                .byte $3F,$3F,$3C,$3C,$3C,$3C,$3C,$3C
                .byte $FC,$F0,$00,$00,$00,$00,$00,$00
                ; .CCC CC..
                ; .CCC CCC.
                ; .CCC CCCC
                ; .CC. .CCC
                ; .CC. ..CC
                ; .CC. ..CC
                ; .CC. .CCC
                ; .CCC CCCC

                ; .CCC CCC.
                ; .CCC CC..
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....

                .byte $FC,$F0,$F0,$FC,$3C,$3F,$0F,$0F   ; [R - leg]
                ; CCC.
                ; CC..
                ; CC..
                ; CCC.
                ; .CC.
                ; .CCC
                ; ..CC
                ; ..CC

                .byte $3F,$3F,$3F,$3C,$3C,$3C,$3F,$3F   ; [E]
                .byte $FC,$FC,$FC,$00,$00,$00,$FC,$FC
                .byte $3F,$3C,$3C,$3C,$3C,$3F,$3F,$3F
                .byte $FC,$00,$00,$00,$00,$FC,$FC,$FC
                ; .CCC CCC.
                ; .CCC CCC.
                ; .CCC CCC.
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CCC CCC.
                ; .CCC CCC.

                ; .CCC CCC.
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CC. ....
                ; .CCC CCC.
                ; .CCC CCC.
                ; .CCC CCC.
