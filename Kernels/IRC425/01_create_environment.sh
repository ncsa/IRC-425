#!/bin/bash

# shamelessly lifted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh

jupyter_custom_kernel_name="IRC425"
jupyter_custom_kernel_version="latest"

#icrn_runtime_context="dryrun"
icrn_runtime_context="Dev"
#icrn_runtime_context="UAT"
#icrn_runtime_context="Prod"

echo "beginning installation in context: "$icrn_runtime_context
sleep 5s


if [ "$icrn_runtime_context" == "Prod" ]; then
  base_conda_directory="/sw/icrn/jupyter/icrn_ncsa_resources"
elif [ "$icrn_runtime_context" == "UAT" ]; then
  base_conda_directory="/sw/icrn/jupyter/TEST_icrn_ncsa_resources"
else
  base_conda_directory="$HOME/.conda/icrn_ncsa_resources"
fi

icrn_base_working_dir=$PWD
icrn_environments_path="$base_conda_directory/icrn_ncsa_managed_environments"
icrn_custom_channel_path="$base_conda_directory/icrn_ncsa_custom_channel"

working_directory="./Kernels/"$jupyter_custom_kernel_name"/"
json_tags="$working_directory/environment_tags.json"

echo "Set and Interpreted Variables:"
echo "base working directory for this install: "$icrn_base_working_dir
echo "conda ICRN NCSA environments location: "$icrn_environments_path
echo "conda channel location: "$icrn_custom_channel_path

declare -a directory_array=("$icrn_custom_channel_path" "$icrn_environments_path")
echo "Checking directory resource existence..."
for i in "${directory_array[@]}"
do
  if [ ! -d "$i" ]; then
    echo "$i does not exist, but it needs to - Exiting."
    return 1
  else
    echo "$i exists."
  fi
done

export icrn_runtime_context
export jupyter_custom_kernel_name
export jupyter_custom_kernel_version
export icrn_custom_channel_path
export icrn_base_working_dir
export icrn_environments_path

echo "invoking kernel_1_prepare.sh"
if source $working_directory"/kernel_resources/kernel_1_prepare.sh"; then
  echo 'Prepared kernel correctly.'
else
  echo "Couldn't prepare kernel."
  return
fi

echo "Invoking kernel_2_populate.sh"
if source $working_directory"/kernel_resources/kernel_2_populate.sh"; then
  echo 'Installed packages into kernel.'
else
  echo "Error during package installation."
  return
fi

# removing auto-install. this is not needed when creating the kernels in 'prod', as the user of these kernels
# will install it on their own. The users also will install these kernels on their own when they are ready to do so.
#echo "Invoking kernel_3_install.sh"
#if source $working_directory"/kernel_resources/kernel_3_install.sh"; then
#  if [ "$icrn_runtime_context" == "Prod" ]; then
#    echo 'Installed kernel into jupyter.'
#  else
#    echo 'Intentionally did not install kernel into jupyter - not running in production.'
#  fi
#else
#  echo "Error during kernel installation."
#  return
#fi


echo "Custom environment creation and jupyter kernel installation complete."
echo "base working directory for this install: $icrn_base_working_dir"
echo "conda channel location: $icrn_custom_channel_path"

echo "Beginning Extension Installation..."
sleep 5s
if source $working_directory"/extension_resources/extensions_1_install_extensions.sh"; then
  if [ "$icrn_runtime_context" == "Prod" ]; then
    echo 'Installed extensions into jupyter - be certain you use the correct kernel with these extensions.'
  else
    echo 'Intentionally did not install extensions into jupyter - not running in production.'
  fi
else
  echo "Error during extension installation."
  return
fi

echo "removing environment variables"
unset icrn_runtime_context
unset jupyter_custom_kernel_name
unset jupyter_custom_kernel_version
unset icrn_custom_channel_path
unset icrn_base_working_dir
unset icrn_environments_path