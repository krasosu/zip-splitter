#!/bin/bash

WORKING_DIR=/tmp/.archive-splitter/working
WORKING_ALL_DIR=$WORKING_DIR/all
WORKING_FILES_DIR=$WORKING_DIR/files

OUT_DIR=splitter/out

# clean up 
rm -r $WORKING_DIR
rm -r $OUT_DIR



mkdir -p $WORKING_DIR
mkdir -p $WORKING_ALL_DIR
mkdir -p $WORKING_FILES_DIR
mkdir -p $OUT_DIR


while getopts i:s: flag
do
    case "${flag}" in
        i) input=${OPTARG};;
        s) split=${OPTARG};;
    esac
done


echo
echo "###########################################"
echo "input archive: $input";
echo "split size: $split";
echo "###########################################"
echo

# unzip input archive file with progress bar
unzip $input -d $WORKING_ALL_DIR | pv


counter=1;

for file in $WORKING_ALL_DIR/*; do


    mv $file $WORKING_FILES_DIR/
   
    if [ $counter == $split ]
    
    then
    
      filename=$RANDOM.zip
            
      zip -jr $OUT_DIR/$filename.zip $WORKING_FILES_DIR/
      echo "created `pwd`/$OUT_DIR/$filename"
      
      rm $WORKING_FILES_DIR/*
      counter=0
    fi
    
    counter=$((counter+1))

done

# zip remaining files
zip -jr $OUT_DIR/$RANDOM.zip $WORKING_FILES_DIR/
rm $WORKING_FILES_DIR/*
