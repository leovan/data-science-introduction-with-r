#!/bin/bash

# go to slides images directory
cd $(dirname $(dirname $(dirname $(dirname "$0"))))
cd static/images/lecture

# resize all images
for image in ./*.png
do
    convert -resize 800x ${image} ${image}
done
