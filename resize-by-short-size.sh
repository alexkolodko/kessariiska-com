#!/bin/bash

min_size=300

# Ignore case, and suppress errors if no files 
shopt -s nullglob
shopt -s nocaseglob

# Process all image files
for f in *.gif *.png *.jpg; do

    # Get image's width and height, in one go
    read w h < <(identify -format "%w %h" "$f")


    if [ $w -eq $h ]; then
 
# SQUARE   	
        echo $f - ${w}x${h} "==>" ${min_size}x${min_size}
        convert $f -resize "${min_size}x${min_size}" -quality 85 thumbs/$f

# RETINA SQUARE
		let retina_min_size="$min_size*2"
        echo $f - ${w}x${h}  "==>"
        retina_f="${f%.*}@2x.${f##*.}"
        convert $f -resize "${retina_min_size}x${retina_min_size}" -quality 85 thumbs/retina_f

    elif [ $h -gt $w ]; then

# VERTICAL    	
		let short=$min_size
		let "long= ($h*$short)/$w"
		echo $f - ${w}x${h}  "==>" ${short}x${long}
		convert $f -resize "${short}x${long}" -quality 85 thumbs/$f


# RETINA VERTICAL
        let retina_short="$short*2"
        let retina_long="$long*2"
        echo $f - ${w}x${h}  "==>" @2x ${retina_short}x${retina_long} 
        retina_f="${f%.*}@2x.${f##*.}"
        convert $f -resize "${retina_short}x${retina_long}" -quality 85 thumbs/$retina_f

    else

# HORIZONTAL         
		let short=$min_size
		let "long= ($w*$short)/$h"
        echo $f - ${w}x${h}  "==>" ${long}x${short}
        convert $f -resize "${long}x${short}" -quality 85 thumbs/$f


# RETINA HORIZONTAL
        let retina_short="$short*2"
        let retina_long="$long*2"
        echo $f - ${w}x${h}  "==>" @2x ${retina_long}x${retina_short} 
        retina_f="${f%.*}@2x.${f##*.}"        
        convert $f -resize "${retina_long}x${retina_short}" -quality 85 thumbs/$retina_f
    fi

done