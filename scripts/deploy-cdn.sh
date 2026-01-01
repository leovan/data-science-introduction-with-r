#!/bin/bash

current_dir=$(pwd)
cd "$(dirname "$0")"
script_dir=$(pwd)

cd "${script_dir}/.."

edgeone pages deploy cdn -n ds-r-cdn
