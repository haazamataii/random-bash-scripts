#!/bin/bash
home=$(pwd)
cd "$home"

work=$1
if [[ -z $1 ]]; then
 work="./"
fi

#get inodes of self and children until there are no more children
inodes=$(find "$work" -type d -printf "%i\n") #inodes for compatibility

for inode in ${inodes}; do
 dir="$(find "$work" -inum $inode)" #Convert inode to valid directory(find "${dir}" -type d doesnt always produce valid paths but inodes do)
 echo "Converting to WebP: $dir"
 cd "$dir"
 mogrify -format webp -define webp:lossless=true -define webp:method=6 *.[Pp][Nn][Gg] *.[Gg][Ii][Ff] *.[Hh][Ee][Ii][Cc] > /dev/null 2>&1 #convert lossless format to lossless WebP
 rm *.[Pp][Nn][Gg] *.[Gg][Ii][Ff] *.[Hh][Ee][Ii][Cc] > /dev/null 2>&1 #Remove old imgs
 cd "$home"
done
