#!/bin/bash

# go to root directory of slides
cd $(dirname $(dirname $(dirname "$0")))

# slides directories
slides_directories=(
    "01-data-science-introduction"
    "02-r-language-introduction"
    "03-data-analytics-introduction-part-1"
    "04-data-analytics-introduction-part-2"
    "05-data-visualization"
    "06-statistical-analytics-introduction"
    "07-feature-engineering"
    "08-model-evaluation-and-hyperparameter-optimization"
    "09-classification-algorithms-part-1"
    "10-classification-algorithms-part-2"
    "11-clustering-algorithms"
    "12-time-series-algorithms"
    "13-deep-learning-algorithms"
    "14-reproducible-research"
)

# link base resources
for slide_dir in ${slides_directories[*]}
do
    if [ -L ${slide_dir}/assets ]
    then
        rm ${slide_dir}/assets
    fi

    if [ -L ${slide_dir}/css ]
    then
        rm ${slide_dir}/css
    fi

    if [ -L ${slide_dir}/includes ]
    then
        rm ${slide_dir}/includes
    fi

    cd ${slide_dir}
    ln -s ../_common/assets assets
    ln -s ../_common/css css
    ln -s ../_common/includes includes
    cd ..
done
