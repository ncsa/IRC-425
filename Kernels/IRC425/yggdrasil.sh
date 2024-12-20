#!/bin/bash
#TODO: need to either put these in a config or environment vars - pasting at top of every sh is crap
custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"

target_conda_environment_location="$HOME/scratch/Conda/Envs/$custom_kernel"

iam="yggdrasil"

echo "installing "$iam
cd $custom_kernel_path"/"$iam || return
echo "resolving git submodules for "$iam
git submodule init
git submodule update
echo "running pip install for "$iam
pip install . || return
echo "Done."
# really.
cd ../../../
# yggdrasil done