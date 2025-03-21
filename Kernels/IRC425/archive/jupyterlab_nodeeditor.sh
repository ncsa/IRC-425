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

iam="jupyterlab_nodeeditor"

echo "installing "$iam
cd $working_directory"/"$iam || return
echo "current dir: ${PWD}"
git submodule update --init --recursive
conda remove -y r-base
conda install -y -c conda-forge jupyterlab
conda install -y ipywidgets
conda install -y nodejs
pip install -e "."
# Link your development version of the extension with JupyterLab
jupyter labextension develop . --overwrite
# Server extension must be manually installed in develop mode
jupyter server extension enable jupyterlab_nodeeditor
# Rebuild extension Typescript source after making changes
jlpm build
echo "Done."
# really.
cd ../../../
echo "current dir: ${PWD}"
# jupyterlab nodeeditor done