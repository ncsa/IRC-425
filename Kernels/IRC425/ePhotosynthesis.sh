#!/bin/bash
# manual install record; much changes needed for automation

#TODO: need to either put these in a config or environment vars - pasting at top of every sh is crap
custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"
iam="ePhotosynthesis_C"
target_conda_environment_location="$HOME/scratch/Conda/Envs/$custom_kernel"

echo "installing ePhotosynthesis_C"
cd $custom_kernel_path"/ePhotosynthesis_C" || return
echo "current dir: ${PWD}"
git submodule update --init --recursive
conda install -y -c conda-forge 'sundials<=5.7.0'
conda install -y boost
conda install -y 'cmake>=3.10'
conda install -y cxx-compiler
mkdir Build || return

echo "current dir: ${PWD}"
cd Build || return
echo 'cmake call'
cmake ../ || return
echo 'first make'
make || return
echo 'make install'
make DESTDIR="$CONDA_PREFIX"/lib install
echo "Done."
# really.
cd ../../../../
echo "current dir: ${PWD}"
# ePhotosynthesis_C done