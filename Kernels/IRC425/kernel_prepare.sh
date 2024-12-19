#!/bin/bash
# manual install record; much changes needed for automation

custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"
echo "Starting kernel preparation"
echo "preparing conda environment"
conda config --add channels conda-forge

conda create -y -n $custom_kernel python=3.11
echo "created conda environment: "$custom_kernel
eval $(conda shell.bash hook)
if conda activate $custom_kernel
then
        echo "activated "$custom_kernel
else
        echo ERROR: Could not activate conda environment.
        exit 1
fi
pip install jupyterlab
conda install -y git
conda install -y jq
echo "Done preparing kernel"