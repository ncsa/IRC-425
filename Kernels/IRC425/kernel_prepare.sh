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
python_version="3.11"

echo "Starting kernel preparation"
echo "preparing conda environment"
conda config --add channels conda-forge

if conda create -y --prefix "$target_conda_environment_location" python=$python_version
then
  echo "created conda environment: "$target_conda_environment_location
else
  echo ERROR: Could not create conda environment.
  return 1
fi

eval "$(conda shell.bash hook)"
if conda activate "$target_conda_environment_location"
then
        echo "activated ""$target_conda_environment_location"
else
        echo ERROR: Could not activate conda environment.
        return 1
fi

conda install -y git jq
echo "Done preparing kernel"