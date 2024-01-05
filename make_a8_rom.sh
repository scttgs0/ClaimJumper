
mkdir -p obj/

# -------------------------------------

64tass  --m65xx \
        --atari-xex \
        -b \
        -o obj/claimjumper.rom \
        --list=obj/claimjumper_a8.lst \
        --labels=obj/claimjumper_a8.lbl \
        claimjumper.asm
