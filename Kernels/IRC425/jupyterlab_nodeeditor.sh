#!/bin/bash
#TODO: need to either put these in a config or environment vars - pasting at top of every sh is crap
custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"

target_conda_environment_location="$HOME/scratch/Conda/Envs/$custom_kernel"

iam="jupyterlab_nodeeditor"

echo "installing "$iam
cd $custom_kernel_path"/"$iam || return
echo "current dir: ${PWD}"
git submodule update --init --recursive
conda remove -y r-base
conda install -y -c conda-forge jupyterlab
conda install -y ipywidgets
pip install -e "."
# Link your development version of the extension with JupyterLab
jupyter labextension develop . --overwrite
# Server extension must be manually installed in develop mode
jupyter server extension enable jupyterlab_nodeeditor
# Rebuild extension Typescript source after making changes
jlpm build
echo "Done."
# really.
cd ../../../
echo "current dir: ${PWD}"
# yggdrasil done