#! /bin/bash

# Vraag 1
ARCHIVE=$1
tar -xzf $ARCHIVE
ARCHIVE=$(sed 's/\([^_]*_[^_]*_[^_]*_[^_]*_[^_]*\).tgz/\1/g' <<< $ARCHIVE)
VAK=$(sed 's/[^_]*_[^_]*_\([^_]*\)_[^_]*_[^_]*/\1/g' <<< $ARCHIVE)
TAAK=$(sed 's/[^_]*_[^_]*_[^_]*_\([^_]*\)_[^_]*/\1/g' <<< $ARCHIVE)
DEADLINE=$(date -d $(sed 's/[^_]*_[^_]*_[^_]*_[^_]*_\([^.]*\)/\1/g' <<< $ARCHIVE) +%s)

mv $ARCHIVE $VAK
cd $VAK
mkdir $TAAK
mv *.tgz $TAAK
cd ..

# Vraag 2
cd $VAK/$TAAK
for f in *.tgz
do
    mv "$f" "${f// /}" 2>/dev/null
done
for l in *.tgz
do
    tar -xzf $l
    rm $l
done
for m in *
do
    mv "$m" "${m// /}" 2>/dev/null
done
for n in *
do
    VOORNAAM=$(sed 's/[^_]*_\([^.]*\).[^_]*[^.]*/\1/g' <<< $n)
    ACHTERNAAM=$(sed 's/[^_]*_[^.]*.\([^.]*\).[^_]*[^.]*/\1/g' <<< $n)
    SUB_DATE=$(date -d $(sed 's/[^_]*_[^.]*.[^.]*.s.ua_poging_\([^.]*\)/\1/g' <<< $n) +%s)
    mkdir $ACHTERNAAM.$VOORNAAM
    mv $n/* $ACHTERNAAM.$VOORNAAM
    rm -r $n
    # Vraag 3
    if [ $DEADLINE -lt $SUB_DATE ]
    then
        cd $ACHTERNAAM.$VOORNAAM
        touch late_inzending
        cd ..
    fi
    cd $ACHTERNAAM.$VOORNAAM
    for o in *
    do
        if [ -d $o ]
        then
            cd $o
            for p in *
            do
                mv $p ..
            done
            cd ..
            rm -r $o
        fi
    done
    # Vraag 4
    for q in *
    do
        FILE_EXT=$(sed 's/[^.]*\(.[a-z]*\)/\1/g' <<< $q)
        if [ $FILE_EXT != $2 ] && [ $q != 'late_inzending' ]
        then
            rm $q
        fi
    done
    cd ..
done