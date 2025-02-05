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

iam="ePhotosynthesis_C"

echo "installing ePhotosynthesis_C"
cd $working_directory"/ePhotosynthesis_C" || return
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