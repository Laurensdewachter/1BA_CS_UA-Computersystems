#! /bin/bash

ACHTERNAAM=$(sed 's/\([^.]*\).\([^.]*\)/\1/g' <<< $1)
VOORNAAM=$(sed 's/\([^.]*\).\([^.]*\)/\2/g' <<< $1)
cd $ACHTERNAAM.$VOORNAAM        # Enter student directory
for a in *                      # Iterate all files
do
    if [ $a != 'late_inzending' ]       # Exclude the "late_inzending" file
    then
        python3 $a > $ACHTERNAAM.$VOORNAAM\_$(sed 's/\([^.]*\).py/\1/g' <<< $a)_output.txt          # Export output
        mv $ACHTERNAAM.$VOORNAAM\_$(sed 's/\([^.]*\).py/\1/g' <<< $a)_output.txt ../Oplossingen     # Move output to solutions directory
        ERROR=$?
        touch $ACHTERNAAM.$VOORNAAM\_$(sed 's/\([^.]*\).py/\1/g' <<< $a)_error.txt                  # Create error file      
        if [ $ERROR -ne 0 ]                                                                         # Check if there was an error
        then
            python3 $a 2>$ACHTERNAAM.$VOORNAAM\_$(sed 's/\([^.]*\).py/\1/g' <<< $a)_error.txt       # Export error to error file
        fi
        mv $ACHTERNAAM.$VOORNAAM\_$(sed 's/\([^.]*\).py/\1/g' <<< $a)_error.txt ../Oplossingen      # Move error file to solutions directory
    fi
done
cd ..