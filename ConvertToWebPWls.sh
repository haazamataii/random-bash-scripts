#!/bin/bash

home=$(pwd)
cd "$home"

#work directory
work=$1
if [[ -z $1 ]]; then
 work="./"
fi

#set depth var (default 1)
depth=$2
if [[ -z $2 ]]; then
 depth=1
fi

#ls command started (directories and hidden)
ls_cmd="ls -da "

i=0
while [[ "$i" != "$depth" ]]; do
 ls_cmd+="*/"
 i=$((i+1))

 #setup for ls to work properly
 cd "$work"
 shopt -s dotglob
 #map ls results as array
 mapfile -t dirMap < <($ls_cmd 2>/dev/null | sed 's:/$::' | tr -d '\r')
 #cleanup
 shopt -u dotglob
 #go through array
 for dir in "${dirMap[@]}"; do
 #cd into directory
  cd "$home"
  cd "$work"
  cd "$dir"

  #mogrify/convert the files, then delete originals
  echo "Converting to WebP: $dir"
  mogrify -format webp -define webp:lossless=true *.[Pp][Nn][Gg] *.[Gg][Ii][Ff] *.[Hh][Ee][Ii][Cc] > /dev/null 2>&1 #convert lossless format to lossless WebP
  rm *.[Pp][Nn][Gg] *.[Gg][Ii][Ff] *.[Hh][Ee][Ii][Cc] > /dev/null 2>&1 #Remove old imgs
 
 done

 cd "$home"
done
