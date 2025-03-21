#!/bin/bash

# multiple environment variables are assumed to exist when this script is invoked
# executing this script in a standalone fashion will not be successful at this time.

echo "Starting kernel preparation"
echo "preparing conda environment"

if conda create -y --prefix "$icrn_environments_path/$jupyter_custom_kernel_name"
then
  echo "created conda environment: ""$icrn_environments_path/$jupyter_custom_kernel_name"
else
  echo ERROR: Could not create conda environment.
  return 1
fi

eval "$(conda shell.bash hook)"
if conda activate "$icrn_environments_path/$jupyter_custom_kernel_name"
then
        echo "activated $icrn_environments_path/$jupyter_custom_kernel_name"
else
        echo ERROR: Could not activate conda environment.
        return 1
fi

conda config --add channels conda-forge
conda config --add channels $icrn_custom_channel_path
conda config --set channel_priority strict

conda install -y conda-build conda-verify git jq ipykernel

echo "Done preparing kernel"
return 0