#!/bin/bash

# shamelessly lifted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh

if [[ -z "${icrn_base_working_dir}" ]]; then
  echo ERROR: could not determine ICRN base working directory: icrn_base_working_dir
  return 1
fi

if [[ -z "${icrn_runtime_context}" ]]; then
  echo ERROR: Could not determine icrn runtime context from unset variable: icrn_runtime_context
  return 1
fi

if [[ -z "${icrn_package_tarballs}" ]]; then
  echo ERROR: Environment variable unset: icrn_package_tarballs
  return 1
fi

if [[ -z "${icrn_custom_recipes_path}" ]]; then
  echo ERROR: Environment variable unset: icrn_custom_recipes_path
  return 1
fi

if [[ -z "${icrn_prebuilt_recipes_path}" ]]; then
  echo ERROR: Environment variable unset: icrn_prebuilt_recipes_path
  return 1
fi

if [[ -z "${icrn_custom_channel_path}" ]]; then
  echo ERROR: Environment variable unset: icrn_custom_channel_path
  return 1
fi

working_directory="./Recipes"
json_tags="$working_directory/recipe_tags.json"

conda_install_env="IRC425_Installs"
# python -m conda_index
# create the subdirs, get the git repos, add them as submodules if needed, checkout branches
conda config --add channels conda-forge

if conda create -y -p ${icrn_environments_path}"/"${conda_install_env}
then
  echo "created conda environment: "${icrn_environments_path}"/"${conda_install_env}
else
  echo ERROR: Could not create conda environment.
  return 1
fi

eval "$(conda shell.bash hook)"
if conda activate ${icrn_environments_path}"/"${conda_install_env}
then
        echo "activated ""${icrn_environments_path}"/"${conda_install_env}"
else
        echo ERROR: Could not activate conda environment.
        return 1
fi

echo "Installing needed packages for compilation/download and parsing... "
conda install -c conda-forge -y conda-build conda-verify git jq grayskull cmake make boost cxx-compiler

echo "Done preparing base install environment."
