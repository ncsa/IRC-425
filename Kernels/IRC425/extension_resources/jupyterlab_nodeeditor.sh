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

echo "installing extension: "$iam
cd $working_directory"/"$iam || return
echo "current dir: ${PWD}"

# Link your development version of the extension with JupyterLab
echo "activating base environment to install into active jupyter instance"
conda activate base
echo $iam" extension: jupyter labextension develop . --overwrite"
jupyter labextension develop . --overwrite
# Server extension must be manually installed in develop mode
echo $iam" extension: jupyter server extension enable jupyterlab_nodeeditor"
jupyter server extension enable jupyterlab_nodeeditor
# Rebuild extension Typescript source after making changes
echo $iam" extension: jlpm build"
jlpm build
echo "Done installing extension: $iam"
# really.
cd ../../../
echo "current dir: ${PWD}"