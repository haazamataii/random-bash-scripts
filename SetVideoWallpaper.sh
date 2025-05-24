#!/bin/bash

###
###### FUNCTION DEFINITIONS
###

#draw with sleep for time between frames
drawWSleep() {
 while true; do
  i=0
  feh_cmd=""
  #build feh command with frame counters
  while [[ $i != $videoCount ]]; do
   feh_cmd+="\"$i\"_${currFrames[$i]}.jpg "
   currFrames[$i]=$((${currFrames[$i]}+1))
   #loop back to first frame (1 indexed)
   if [[ ${currFrames[$i]} == ${maxFrames[$i]} ]]; then
    currFrames[$i]=1
   fi
   i=$((i+1))
  done
  #have to eval for correct image path/name
  eval "feh --no-fehbg -p --bg-$scale $feh_cmd"
  sleep $seconds
 done
}

#draw without sleep, mostly here for weaker systems that cant draw fast enough with sleep
#Maybe even not fast enough even without sleep
drawWoSleep() {
 while true; do
  i=0
  feh_cmd=""
  #build feh command with frame counters
  while [[ $i != $videoCount ]]; do
   feh_cmd+="\"$i\"_${currFrames[$i]}.jpg "
   currFrames[$i]=$((${currFrames[$i]}+1))
   #loop back to first frame (1 indexed)
   if [[ ${currFrames[$i]} == ${maxFrames[$i]} ]]; then
    currFrames[$i]=1
   fi
   i=$((i+1))
  done
  #have to eval for correct image path/name
  eval "feh --no-fehbg -p --bg-$scale $feh_cmd"
 done 
}

###
#####START OF SCRIPT
###

#make backgrounds dir
mkdir -p ~/.desktopBackground/
home=$(pwd)
cd ~/.desktopBackground
rm -r * > /dev/null 2>&1
cd "$home"

#clean if user wants clean
if [[ $1 == "clean" ]]; then
 rmdir ~/.desktopBackground/ > /dev/null 2>&1
 echo "Cleaned ~/.desktopBackground/ dir"
 exit 0
fi

#check for min arg count
if [[ -z "$8" ]]; then
    echo "Usage: $0 -v <video_file> -f <framerate> -s <scale> -r <resolution>"
    exit 1
fi


#Go through args
state=""
for arg in ${@}; do
 if [[ -z "$state" ]]; then
  #isolate state
  state="$(echo $arg | tr '[:lower:]' '[:upper:]')"
  state="${state:1:1}"
  if [[ $state == "D" ]]; then
   #no sleep
   skipSleep="T"
   state=""
  fi
 else
  #set state vars
  case $state in
   "V")
    videos+=("$arg")
    ;;
   "R")
    resolutions+=("$arg")
    ;;
   #these 3 are set once (overwrites if another of the same option gets supplied)
   "F")
    framerate=("$arg")
    ;;
   "S")
    scale=("$arg")
    ;;
   "T")
    seconds=("$arg")
    ;;
   *)
    echo "INVALID OPTION: -$state"
    exit 2
    ;;
  esac
  state=""
 fi
done

#have ffmpeg convert frames to jpg (in self testing, the fastest image type for video background)
i=0
videoCount="${#videos[@]}"
while [[ $i !=  $videoCount ]]; do
 echo "Working on: ${videos[$i]}"
 ffmpeg -loglevel warning -i "${videos[$i]}" -q:v 5 -vf "scale=${resolutions[$i]},fps=${framerate[$i]}" ~/.desktopBackground/"$i"_%0d.jpg
 i=$((i+1))
done

#go into backgrounds
cd ~/.desktopBackground/

#setup frame counters and get frame counts
i=0
while [[ $i != $videoCount ]]; do
 frameCount=($(ls ${i}_*))
 maxFrames+=($((${#frameCount[@]}+1)))
 currFrames+=(1)
 i=$((i+1))
done

#call selected draw function
if [[ $skipSleep == "T" ]]; then
 drawWoSleep
else
 drawWSleep
fi
