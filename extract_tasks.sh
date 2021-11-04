#! /bin/bash

ARCHIVE=$1
tar -xvzf $ARCHIVE

VAK=$(sed 's/[^_]*_[^_]*_\([^_]*\)_[^_]*_[^_]*/\1/g' <<< $ARCHIVE)
TAAK=$(sed 's/[^_]*_[^_]*_[^_]*_\([^_]*\)_[^_]*/\1/g' <<< $ARCHIVE)
mkdir $VAK
cd $VAK
mkdir $TAAK
cd ..
cd ..