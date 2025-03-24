#!/bin/bash

# multiple environment variables are assumed to exist when this script is invoked
# executing this script in a standalone fashion will not be successful at this time.

echo "Starting kernel preparation"
echo "preparing conda environment"

if [ "$icrn_runtime_context" == "dryrun" ]; then
  echo "Dryrun: "
  echo 'conda create -y --prefix '"$icrn_environments_path/$jupyter_custom_kernel_name"
else
  if conda create -y --prefix "$icrn_environments_path/$jupyter_custom_kernel_name"
  then
    echo "created conda environment: ""$icrn_environments_path/$jupyter_custom_kernel_name"
  else
    echo ERROR: Could not create conda environment.
    return 1
  fi
fi

if [ "$icrn_runtime_context" == "dryrun" ]; then
  echo "Dryrun: "
  echo 'eval "$(conda shell.bash hook)"'
  echo 'conda activate '"$icrn_environments_path/$jupyter_custom_kernel_name"
else
  eval "$(conda shell.bash hook)"
  if conda activate "$icrn_environments_path/$jupyter_custom_kernel_name"
  then
          echo "activated $icrn_environments_path/$jupyter_custom_kernel_name"
  else
          echo ERROR: Could not activate conda environment.
          return 1
  fi
fi
if [ "$icrn_runtime_context" == "dryrun" ]; then
  echo "Dryrun: "
  echo 'conda config --add channels conda-forge'
  echo 'conda config --add channels '$icrn_custom_channel_path
  echo 'conda config --set channel_priority strict'
  echo 'conda install -y conda-build conda-verify git jq ipykernel'
else
  conda config --add channels conda-forge || return 1
  conda config --add channels $icrn_custom_channel_path || return 1
  conda config --set channel_priority strict || return 1
  conda install -y conda-build conda-verify git jq ipykernel || return 1
fi

echo "Done preparing kernel"
return 0