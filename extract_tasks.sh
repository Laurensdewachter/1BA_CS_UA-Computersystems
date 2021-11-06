#! /bin/bash

# Vraag 1
ARCHIVE=$1
tar -xzf $ARCHIVE
ARCHIVE=$(sed 's/\([^_]*_[^_]*_[^_]*_[^_]*_[^_]*\).tgz/\1/g' <<< $ARCHIVE)
VAK=$(sed 's/[^_]*_[^_]*_\([^_]*\)_[^_]*_[^_]*/\1/g' <<< $ARCHIVE)
TAAK=$(sed 's/[^_]*_[^_]*_[^_]*_\([^_]*\)_[^_]*/\1/g' <<< $ARCHIVE)
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
    DATUM=$(sed 's/[^_]*_[^.]*.[^.]*.s.ua_poging_\([^.]*\)/\1/g' <<< $n)
    mkdir $ACHTERNAAM.$VOORNAAM
    mv $n/* $ACHTERNAAM.$VOORNAAM
    rm -r $n
done