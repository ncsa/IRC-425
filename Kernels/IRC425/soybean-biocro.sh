#!/bin/bash
#TODO: need to either put these in a config or environment vars - pasting at top of every sh is crap
custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"

target_conda_environment_location="$HOME/scratch/Conda/Envs/$custom_kernel"

iam="Soybean-BioCro"

echo "installing "$iam
cd $custom_kernel_path"/"$iam || return
echo "current dir: ${PWD}"
echo "resolving git submodules for "$iam
git submodule update --init --recursive
echo "Installing R and deps for "$iam
conda install -y -c r r-base=3.6.3
conda install -y -c r r-lattice
echo "running R cmd install for "$iam
R CMD INSTALL biocro || return
echo "Done."
# really.
cd ../../../
echo "current dir: ${PWD}"
# yggdrasil done