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
 #mogrify/convert the files, then delete originals
 echo "Converting to WebP: $dir"
 mogrify -format webp -define webp:lossless=true *.[Pp][Nn][Gg] *.[Gg][Ii][Ff] *.[Hh][Ee][Ii][Cc] > /dev/null 2>&1 #convert lossless format to lossless WebP
 rm *.[Pp][Nn][Gg] *.[Gg][Ii][Ff] *.[Hh][Ee][Ii][Cc] > /dev/null 2>&1 #Remove old imgs
done

cd "$home"
