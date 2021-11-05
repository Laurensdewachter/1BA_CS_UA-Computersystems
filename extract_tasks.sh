#! /bin/bash

ARCHIVE=$1
tar -xzf $ARCHIVE
ARCHIVE=$(sed 's/\([^_]*_[^_]*_[^_]*_[^_]*_[^_]*\).tgz/\1/g' <<< $ARCHIVE)
VAK=$(sed 's/[^_]*_[^_]*_\([^_]*\)_[^_]*_[^_]*/\1/g' <<< $ARCHIVE)
TAAK=$(sed 's/[^_]*_[^_]*_[^_]*_\([^_]*\)_[^_]*/\1/g' <<< $ARCHIVE)
mv $ARCHIVE $VAK
cd $VAK
mkdir $TAAK
mv *.tgz $TAAK
cd $TAAK
AMOUNT_OF_FILES= ls | wc -l

