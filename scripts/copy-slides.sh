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

if [ -d "${script_dir}/../cdn/slides" ]; then
    rm -rf "${script_dir}/../cdn/slides"
else
    mkdir -p "${script_dir}/../cdn/slides"
fi

cd "${script_dir}/../cdn/slides"

for slide_folder in ${slide_folders[*]}
do
    if [ -d ${slide_folder} ]; then
        rm -rf ${slide_folder}/*
    else
        mkdir ${slide_folder}
    fi

    cd ${slide_folder}
    cp -R ../../../slides/theme .
    cp -R ../../../slides/${slide_folder}/${slide_folder}.html .
    cp -R ../../../slides/${slide_folder}/${slide_folder}_files .
    cp -R ../../../slides/${slide_folder}/images .
    cp -R ../../../slides/${slide_folder}/tmp .
    cd ..
done

cd "${current_dir}"
