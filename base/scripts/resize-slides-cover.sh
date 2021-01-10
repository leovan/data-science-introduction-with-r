#!/bin/bash

# go to slides images directory
cd ../../docs/images/slides

# resize all images
for image in ./*.png
do
    convert -resize 800x ${image} ${image}
done
