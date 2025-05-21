# Random Bash Scripts

Some random bash script(s)

## Converting images to WebP

Uses inodes to enter directories (max-depth) from specified directory to convert pngs, gifs, and heics to webp.
Why to WebP (especially when heic is smaller) because thats what Jellyfin supports.

### Usage:

```
./ConvertToWebP.sh
./ConvertToWebP.sh startingDirectory
```

When no argument is specified, defaults to `./`
