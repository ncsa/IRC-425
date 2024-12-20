#!/bin/bash
# manual install record; much changes needed for automation

custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"

target_conda_environment_location="$HOME/scratch/Conda/Envs/$custom_kernel"

echo "Starting kernel preparation"
echo "preparing conda environment"
conda config --add channels conda-forge

conda create -y --prefix $target_conda_environment_location python=3.11
echo "created conda environment: "$custom_kernel
eval $(conda shell.bash hook)
if conda activate $target_conda_environment_location
then
        echo "activated "$target_conda_environment_location
else
        echo ERROR: Could not activate conda environment.
        return
fi

conda install -y git jq
echo "Done preparing kernel"