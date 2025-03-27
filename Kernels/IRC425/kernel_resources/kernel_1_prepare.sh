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
# PROBABLY A GOOD IDEA TO GET THESE DEPS FROM SOME SORT OF - I DUNNO - REQUIREMENTS.TXT OR SOMETHING
if [ "$icrn_runtime_context" == "dryrun" ]; then
  echo "Dryrun: "
  echo 'conda install -y -n base conda-libmamba-solver'
  echo 'conda config --add channels conda-forge'
  echo 'conda config --add channels '$icrn_custom_channel_path
  echo 'conda config --set channel_priority strict'
  echo "conda install --solver=libmamba -c r -y conda-build conda-verify git jq ipykernel 'python<=3.11' 'r-base<=3.6.3' r-lattice make 'sundials<=5.7.0' 'cmake>=3.10' boost cxx-compiler jupyterlab ipywidgets nodejs"
else
  conda install -y -n base conda-libmamba-solver
  conda config --add channels conda-forge || return 1
  conda config --add channels $icrn_custom_channel_path || return 1
#  conda config --set channel_priority strict || return 1
  conda install --solver=libmamba -c r -y 'python<=3.11' 'r-base<=3.6.3' r-lattice  || return 1
  conda install --solver=libmamba -y conda-build conda-verify git jq ipykernel 'jupyterlab>=4.0.0' ipywidgets nodejs || return 1
  conda install --solver=libmamba -y make 'sundials<=5.7.0' 'cmake>=3.10' boost cxx-compiler || return 1
#  conda install --solver=libmamba -c r -y conda-build conda-verify git jq ipykernel 'python<=3.11' 'r-base<=3.6.3' r-lattice make 'sundials<=5.7.0' 'cmake>=3.10' boost cxx-compiler jupyterlab ipywidgets nodejs || return 1
fi

echo "Done preparing kernel"
return 0