#!/bin/bash
# manual install record; much changes needed for automation

#TODO: need to either put these in a config or environment vars - pasting at top of every sh is crap
custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"

target_conda_environment_location="$HOME/scratch/Conda/Envs/$custom_kernel"

echo "installing ePhotosynthesis_C"
cd $custom_kernel_path/"ePhotosynthesis_C"
conda install -y boost
conda install -y 'sundials<=5.7.0'
mkdir Build

cd Build
echo 'cmake call'
cmake ../
echo 'first make'
make
echo 'make install'
make DESTDIR=$CONDA_PREFIX/lib install
echo "Done."
# really.
cd ../../../../
# ePhotosynthesis_C done