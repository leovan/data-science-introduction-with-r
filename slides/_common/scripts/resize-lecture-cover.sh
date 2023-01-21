#!/bin/bash

# go to slides images directory
cd ../../static/images/lecture

# resize all images
for image in ./*.png
do
    convert -resize 800x ${image} ${image}
done
