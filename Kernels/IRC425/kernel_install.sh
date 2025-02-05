#!/bin/bash
# manual install record; much changes needed for automation

# env vars specific to icrn custom kernels:
#  jupyter_custom_kernel_path  jupyter_custom_kernel_name  jupyter_custom_kernel_version

if [[ -z "${jupyter_custom_kernel_name}" ]]; then
  echo ERROR: Environment variable unset: jupyter_custom_kernel_name
  return 1
fi

if [[ -z "${jupyter_custom_kernel_version}" ]]; then
  echo ERROR: Environment variable unset: jupyter_custom_kernel_version
  return 1
fi

if [[ -z "${jupyter_custom_kernel_path}" ]]; then
  echo ERROR: Environment variable unset: jupyter_custom_kernel_path
  return 1
fi

target_conda_environment_location="$jupyter_custom_kernel_path/$jupyter_custom_kernel_version/"
custom_kernel="$jupyter_custom_kernel_name"
working_directory="./Kernels/$jupyter_custom_kernel_name/"
json_tags="$working_directory""tags.json"

echo "starting software installs"

# submodule section
# auth required?
for dir in $(jq -r 'keys_unsorted[]' $json_tags); do
  if [ "$dir" == "$custom_kernel" ]; then continue; fi
  install_script=$(jq -r ".\"$dir\".install" $json_tags)
  if [ "$install_script" == "none" ]; then echo $dir": no install"; continue; fi
  source $working_directory"/"$install_script
done
