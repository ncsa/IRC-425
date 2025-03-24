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

iam="yggdrasil"

echo "installing "$iam
cd $working_directory"/"$iam || return
echo "current dir: ${PWD}"
echo "resolving git submodules for "$iam
git submodule update --init --recursive
echo "running pip install for "$iam
pip install . || return
echo "Done."
conda install -y yggdrasil.zmq yggdrasil.r yggdrasil.fortran yggdrasil.sbml yggdrasil.rmq
# really.
cd ../../../
echo "current dir: ${PWD}"
# yggdrasil done