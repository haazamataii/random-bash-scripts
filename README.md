# Random Bash Scripts

Some random bash script(s)

 - [Mass converting images to WebP](#converting-images-to-webp)
 - [Video Backgrounds](#video-backgrounds)
 - [Mass converting images to WebP](#converting-images-to-webp-with-ls)

## Mass converting images to WebP

Uses inodes to enter directories (max-depth) from specified directory to convert pngs, gifs, and heics to webp.
Why to WebP (especially when heic is smaller) because thats what Jellyfin supports.

### Usage:

```
./ConvertToWebP.sh
./ConvertToWebP.sh startingDirectory
```

### Notes:

When no argument is specified, defaults to `./`.

### Requirements:

Needs mogrify from imagemagick to work built with support for webp, png, gif, and heic.

## Video Backgrounds

Use one or more video(s) as a background.

### Usage:

To clean and remove the `~/.desktopBackground/` directory, use:
```
./SetVideoWallpaper.sh clean
```
There are various options, some needed per video, and others only need to be defined once:
```
#multiple uses allowed
-v <videoFile> #specify a video file
-r <resolution> #specify a resolution (in ffmpeg's format of wxh)
#single use
-f <framerate> #specify the framerate in which all video(s) are to have their frames extracted at
-s <scale> #set the scale type used for feh.
#Valid strings in <scale> are (center, fill, max, scale)
-t <seconds> #set the seconds between frames (a decimal since this is with sleep for ms)
-d #disable sleep, draws frames without calling sleep in between them.
#-d is mostly here for lower-end systems that can't draw fast enough without sleep let alone with it
```

### Notes:

The multiple allowed are done per video, each video should have a corrisponding resolution.
The single use can be done multiple times, but it overwrites the old value.
Disable sleep is not a toggle thing so having two options to disable sleep will not turn it back on, not having it as an argument is the only way to allow sleeping.
For scale, `--bg-` gets appended so any feh options that uses this prefix is valid for the scaling option.
Options (the `-?` part) are not case sensitive.

### Requirments:

Needs ffmpeg compiled with jpg support and support for whatever video formats and encoding intended to be used. feh with jpg support is also needed to display the wallpaper.

## Mass converting images to WebP With ls

This one uses ls instead of inodes. This one is faster than the other one testing on my machine.

### Usage:

```
./ConvertToWebPWls.sh
./ConvertToWebPWls.sh startingDirectory
./ConvertToWebPWls.sh startingDirectory depth
```

### Notes:

When no argument is specified, the path defaults to `./` and the depth is 1.
Depth is to be specified as 1 or higher.

### Requirements:

Needs mogrify from imagemagick to work built with support for webp, png, gif, and heic.
