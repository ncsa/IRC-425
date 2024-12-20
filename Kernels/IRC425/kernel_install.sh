#!/bin/bash
# manual install record; much changes needed for automation

custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"

target_conda_environment_location="$HOME/scratch/Conda/Envs/$custom_kernel"
echo "starting software installs"

# submodule section
# auth required?
for dir in $(jq -r 'keys[]' $json_tags | sort); do
  if [ "$dir" == "$custom_kernel" ]; then continue; fi
  tag=$(jq -r ".\"$dir\".tag" $json_tags)
  url=$(jq -r ".\"$dir\".url" $json_tags)
  install_script=$(jq -r ".\"$dir\".install" $json_tags)
  if [ "$install_script" == "none" ]; then echo $dir": no install"; continue; fi
  target_dir=$custom_kernel_path""$dir
  source $custom_kernel_path"/"$install_script
done
