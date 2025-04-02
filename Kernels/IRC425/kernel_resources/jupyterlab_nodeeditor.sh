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


iam="jupyterlab_nodeeditor"

echo "installing "$iam
# working directory here is actually 2 layers, so this is 2+1 deep
cd $working_directory"/"$iam || return
echo "current dir: ${PWD}"
git submodule update --init --recursive
#conda remove -y  --solver=libmamba r-base
conda install -y --solver=libmamba jupyterlab ipywidgets nodejs
echo $iam" package: pip install -e '.' "
pip install -e "."
## Link your development version of the extension with JupyterLab
#jupyter labextension develop . --overwrite
## Server extension must be manually installed in develop mode
#jupyter server extension enable jupyterlab_nodeeditor
## Rebuild extension Typescript source after making changes
#jlpm build
#echo "Done."
# really.
cd ../../../
echo "current dir: ${PWD}"
# jupyterlab nodeeditor done