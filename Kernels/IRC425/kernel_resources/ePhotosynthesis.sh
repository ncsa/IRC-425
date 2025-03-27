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

#if [[ -z "${jupyter_custom_kernel_path}" ]]; then
#  echo ERROR: Environment variable unset: jupyter_custom_kernel_path
#  return 1
#fi

iam="ePhotosynthesis_C"

echo "installing ePhotosynthesis_C"
cd $working_directory"/ePhotosynthesis_C" || return
echo "current dir: ${PWD}"
git submodule update --init --recursive
# conda install --solver=libmamba -y make 'sundials<=5.7.0' 'cmake>=3.10' boost cxx-compiler
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