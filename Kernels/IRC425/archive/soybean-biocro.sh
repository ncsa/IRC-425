#!/bin/bash

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
working_directory="./Kernels/$jupyter_custom_kernel_name/"
json_tags="$working_directory""tags.json"

iam="Soybean-BioCro"

echo "installing "$iam
cd $working_directory"/"$iam || return
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