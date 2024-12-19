#!/bin/bash
#TODO: need to either put these in a config or environment vars - pasting at top of every sh is crap
custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"

iam="yggdrasil"

echo "installing "iam
cd $custom_kernel_path/iam
echo "resolving git submodules for "iam
git submodule init
git submodule update
echo "running pip install for "iam
python utils/manage_requirements.py install pip --for-development --python-only
pip install .
echo "Done."
# really.
cd ../../../
# yggdrasil done