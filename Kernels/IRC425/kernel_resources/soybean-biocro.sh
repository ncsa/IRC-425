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

iam="Soybean-BioCro"

echo "installing "$iam
cd $working_directory"/"$iam || return 1
echo "current dir: ${PWD}"
echo "resolving git submodules for "$iam
git submodule update --init --recursive
echo "Installing R and deps for "$iam

if conda install -y -c r --solver=libmamba 'r<=3.6.3' 'r-base<=3.6.3' r-lattice
then
  echo 'installation of R libraries successful'
else
  echo 'Could not install R libraries for Soybean BioCro - cannot continue.'
  exit
fi

# requires r<=3.6.3; r-base<=3.6.3
echo "running R cmd install for "$iam
if R CMD INSTALL biocro
then
  echo 'installation of biocro successful.'
  cd ../../../
else
  echo 'installation of biocro not successful.'
  cd ../../../
fi
echo "Done."
# really.