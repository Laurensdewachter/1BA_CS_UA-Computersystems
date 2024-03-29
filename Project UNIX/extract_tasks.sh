#! /bin/bash


# Define Inputs
ARCHIVE=$1
PREFIX=$2
EVALUATION_SCRIPT=$3

tar -xzf $ARCHIVE       # Extract .tgz archive
# Get archive name, course, task and deadline
ARCHIVE=$(sed 's/\([^_]*_[^_]*_[^_]*_[^_]*_[^_]*\).tgz/\1/g' <<< $ARCHIVE)
VAK=$(sed 's/[^_]*_[^_]*_\([^_]*\)_[^_]*_[^_]*/\1/g' <<< $ARCHIVE)
TAAK=$(sed 's/[^_]*_[^_]*_[^_]*_\([^_]*\)_[^_]*/\1/g' <<< $ARCHIVE)
DEADLINE=$(date -d $(sed 's/[^_]*_[^_]*_[^_]*_[^_]*_\([^.]*\)/\1/g' <<< $ARCHIVE) +%s)

mv $ARCHIVE $VAK    # Create course directory
cd $VAK
mkdir $TAAK         # Create task directory
mv *.tgz $TAAK
cd ..

cd $VAK/$TAAK
mkdir Oplossingen       # Create solutions directory
for f in *.tgz
do
    mv "$f" "${f// /}" 2>/dev/null # Remove whitespaces in names
done
for l in *.tgz
do
    tar -xzf $l         # Extract student folders and delete .tgz archives
    rm $l
done
for m in *
do
    mv "$m" "${m// /}" 2>/dev/null      # Remove whitespaces in names
done
for n in *      # Iterate student directories
do
    if [ $n != 'Oplossingen' ]      # Exclude solutions directory
    then
        VOORNAAM=$(sed 's/[^_]*_\([^.]*\).[^_]*[^.]*/\1/g' <<< $n)
        ACHTERNAAM=$(sed 's/[^_]*_[^.]*.\([^.]*\).[^_]*[^.]*/\1/g' <<< $n)
        SUB_DATE=$(date -d $(sed 's/[^_]*_[^.]*.[^.]*.s.ua_poging_\([^.]*\)/\1/g' <<< $n) +%s)
        mkdir $ACHTERNAAM.$VOORNAAM         # Make correctly named student directory
        mv $n/* $ACHTERNAAM.$VOORNAAM       # Move everything to new directory
        rm -r $n                            # Remove old (now empty) directory
        if [ $DEADLINE -lt $SUB_DATE ]      # Check for late submissions
        then
            cd $ACHTERNAAM.$VOORNAAM
            touch late_inzending
            cd ..
        fi
        cd $ACHTERNAAM.$VOORNAAM
        for o in *      # Remove nested directories
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
        for q in *      # Filters for items with correct extensions
        do
            FILE_EXT=$(sed 's/[^.]*.\([a-z]*\)/\1/g' <<< $q)
            if [ "$FILE_EXT" != $2 ] && [ $q != 'late_inzending' ]
            then
                rm $q
            fi
        done
        cd ..
        ../../$3 $ACHTERNAAM.$VOORNAAM          # Calls evaluation script on the student driectory
    fi
done
cd ../..