
mkdir -p obj/

# -------------------------------------

64tass  --m65c02 \
        --flat \
        --nostart \
        -D PGX=1 \
        -o obj/claimjumper.pgx \
        --list=obj/claimjumper.lst \
        --labels=obj/claimjumper.lbl \
        claimjumper.asm


64tass  --m65c02 \
        --flat \
        --nostart \
        -D PGX=0 \
        -o obj/claimjumper.bin \
        --list=obj/claimjumperB.lst \
        --labels=obj/claimjumperB.lbl \
        claimjumper.asm
