#!/bin/bash

#home directory
home=$(pwd)
cd "$home"

#work directory
work=$1
if [[ -z $1 ]]; then
 work="./"
fi
cd "$work" || exit 1
work=$(pwd)

#set depth var (default 1)
depth=" -maxdepth "$2
if [[ -z $2 ]]; then
 depth=""
fi

#map ls results as array
mapfile -t dirMap < <(find ./$depth -type d | tr -d '\r')
#go through array
for dir in "${dirMap[@]}"; do
 #cd into directory
 cd "$work"
 cd "$dir"
 echo "Optimizing jpegs: $dir"
 #get the jpeg/jpg files in directory
 mapfile -t fileMap < <(find . -maxdepth 1 -type f -iname "*.jpg" -o -iname "*.jpeg")
 for file in "${fileMap[@]}"; do
  #put through jpegtran to optimize jpeg without altering quality
  jpegtran -optimize -progressive -copy none -outfile "$file" "$file" > /dev/null 2>&1
 done
 echo "Optimizing webps: $dir"
  #send webps through mogrify
 mogrify -format webp -quality 100 -define webp:lossless=true -define webp:method=6 -define webp:alpha-filter=best *.[Ww][Ee][Bb][Pp] > /dev/null 2>&1

done
cd "$home"
