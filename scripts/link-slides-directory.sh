#!/bin/bash

current_dir=$(pwd)
cd "$(dirname "$0")"
script_dir=$(pwd)

slide_folders=(
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

cd "${script_dir}/../slides"

for slide_folder in ${slide_folders[*]}
do
    if [ -L ${slide_folder}/_extensions ]; then
        rm ${slide_folder}/_extensions
    fi

    if [ -L ${slide_folder}/theme ]; then
        rm ${slide_folder}/theme
    fi

    cd ${slide_folder}
    ln -s ../extensions _extensions
    ln -s ../theme theme
    cd ..
done

cd "${current_dir}"
