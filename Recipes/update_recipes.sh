#!/bin/bash

# adapted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh
# get the recipes and/or packages identified
# for each [custom package]: get the [git repo] added as a submodule
# for each [custom package]: get the [custom recipe] from the added submodule and move it to the [target dir]
# for each [custom recipe]: build it into the [target channel]
# for each [prebuilt package]: get the [tarball] into the [package dir]
# for each [tarball] in [package dir]: [grayskull] it into a [recipe]
# for each [prebuilt recipe]: build it into [target channel]

#icrn_runtime_context="dryrun"
#icrn_runtime_context="Prod"
icrn_runtime_context="UAT"

if [ "$icrn_runtime_context" == "Prod" ]; then
  base_conda_directory="/sw/icrn/jupyter/icrn_ncsa_resources"
elif [ "$icrn_runtime_context" == "UAT" ]; then
  base_conda_directory="/sw/icrn/jupyter/TEST_icrn_ncsa_resources"
else
  base_conda_directory="$HOME/.conda/icrn_ncsa_resources"
fi

icrn_base_working_dir=$PWD
icrn_package_tarballs="$base_conda_directory/packages"
icrn_custom_recipes_path="$base_conda_directory/custom_recipes"
icrn_prebuilt_recipes_path="$base_conda_directory/prebuilt_recipes"
icrn_environments_path="$base_conda_directory/icrn_ncsa_managed_environments"
icrn_custom_channel_path="$base_conda_directory/icrn_ncsa_custom_channel"

working_directory="./Recipes"
json_tags="$working_directory/recipe_tags.json"

echo "Set and Interpreted Variables:"
echo "base working directory for this install: "$icrn_base_working_dir
echo "prebuilt package tarball location: "$icrn_package_tarballs
echo "conda custom recipe location: "$icrn_custom_recipes_path
echo "conda prebuilt recipe location: "$icrn_prebuilt_recipes_path
echo "conda ICRN NCSA environments location: "$icrn_environments_path
echo "conda channel location: "$icrn_custom_channel_path

declare -a directory_array=("$icrn_package_tarballs" "$icrn_custom_recipes_path" "$icrn_prebuilt_recipes_path" "$icrn_custom_channel_path" "$icrn_environments_path")
echo "Checking directory resource existence..."
for i in "${directory_array[@]}"
do
  if [ ! -d "$i" ]; then
    echo "$i does not exist. attempting to create it."
    mkdir -p "$i" || return 1
  else
    echo "$i exists."
  fi
done


export icrn_base_working_dir
export icrn_runtime_context
export icrn_package_tarballs
export icrn_custom_recipes_path
export icrn_prebuilt_recipes_path
export icrn_custom_channel_path
export icrn_environments_path

# Prep local install environment
if source $working_directory"/resources/prepare_install_environment.sh"; then
  echo 'created install environment successfully.'
else
  echo "Couldn't create install environment."
  return 1
fi

# Pull resources from git
if source $working_directory"/resources/pull_resources.sh"; then
  echo 'obtained resources from git and/or remote sources.'
else
  echo "Couldn't obtain resources."
  return 1
fi

# Prebuilt packages: use grayskull to obtain recipes
if source $working_directory"/resources/prebuilt_process.sh"; then
  echo 'Launching prebuild package handler...'
else
  echo "ERROR in prebuilt handling."
  return 1
fi


#
#if [ "$runtime_context" == "Prod" ]; then
#  jupyter_ipykernel_name="$jupyter_custom_kernel_name-$jupyter_custom_kernel_version"
#  echo "starting ipykernel installation as "$jupyter_ipykernel_name
#  if python -m ipykernel install --user --name $jupyter_ipykernel_name --display-name="$jupyter_ipykernel_name"
#  then
#    echo "Kernel installation successful"
#  else
#    echo "Error during kernel installation."
#    return
#  fi
#  jupyter kernelspec list
#fi

echo "Custom channel package pull, build, and recipe creation complete."
echo "base working directory for this install: $icrn_base_working_dir"
echo "prebuilt package tarball location: $icrn_package_tarballs"
echo "conda custom recipe location: $icrn_custom_recipes_path"
echo "conda prebuilt recipe location: $icrn_prebuilt_recipes_path"
echo "conda channel location: $icrn_custom_channel_path"

echo "removing environment variables"
unset icrn_base_working_dir
unset icrn_runtime_context
unset icrn_package_tarballs
unset icrn_custom_recipes_path
unset icrn_prebuilt_recipes_path
unset icrn_custom_channel_path