#!/bin/bash

# shamelessly lifted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh

jupyter_custom_kernel_name="IRC425"
jupyter_custom_kernel_version="latest"
runtime_context="dryrun"
#runtime_context="Prod"

if [ "$runtime_context" == "Prod" ]; then
  jupyter_custom_kernel_path="/sw/icrn/jupyter/$jupyter_custom_kernel_name"
else
  jupyter_custom_kernel_path="$HOME/scratch/Conda/Envs/$jupyter_custom_kernel_name"
fi

target_conda_environment_location="$jupyter_custom_kernel_path/$jupyter_custom_kernel_version/"
working_directory="./Kernels/$jupyter_custom_kernel_name/"
json_tags="$working_directory""tags.json"

echo "Set and Interpreted Variables:"
echo "Custom kernel name: "$jupyter_custom_kernel_name
echo "Custom kernel version: "$jupyter_custom_kernel_version
echo "Custom kernel path: "$jupyter_custom_kernel_path
echo "Conda environment destination: "$target_conda_environment_location
echo "Working directory for installs: "$working_directory

if [ -d $target_conda_environment_location ]; then
  echo "[$target_conda_environment_location] exists. Overwrite of existing custom kernels is not supported at this time."
  return
fi

export jupyter_custom_kernel_path
export jupyter_custom_kernel_name
export jupyter_custom_kernel_version

# Env Vars used:
# jupyter_custom_kernel_name, jupyter_custom_kernel_version, jupyter_custom_kernel_path

if source $working_directory"/kernel_prepare.sh"; then
  echo 'Prepared kernel correctly.'
else
  echo "Couldn't prepare kernel."
  return
fi

# create the subdirs, get the git repos, add them as submodules if needed, checkout branches
for dir in $(jq -r 'keys_unsorted[]' $json_tags); do
  if [ "$dir" == "$jupyter_custom_kernel_name" ]; then continue; fi
  tag=$(jq -r ".\"$dir\".tag" $json_tags)
  url=$(jq -r ".\"$dir\".url" $json_tags)
  install_script=$(jq -r ".\"$dir\".install" $json_tags)
  target_dir=$working_directory""$dir

  # submodule handling: add or checkout correct tag
  if [ "$tag" == "null" ]; then
    echo "[$dir] missing tag"
  else
    if [ ! -d $target_dir ]; then
      echo "[$dir] missing submodule"
      git submodule add $url $target_dir
    fi
    git submodule update --init --recursive $target_dir
    echo "[$dir] checking out $tag"
    echo "current dir: ${PWD}"
    cd $target_dir || return
    echo "current dir: ${PWD}"
    git checkout $tag || return
    echo "current dir: ${PWD}"
#    git add $target_dir
    cd ../../../
    echo "current dir: ${PWD}"
    echo "done with: "$tag
  fi
  echo "| ${dir} | ${tag} |"
#  echo "| ${dir} | ${tag} |" >> README.md
done

echo "triggering install processes"
source $working_directory"/kernel_install.sh"
echo "done with installs"

#echo "starting ipykernel installation"
#python -m ipykernel install --user --name CustomKernel01 --display-name="CustomKernel01"
#jupyter kernelspec list

echo "Exporting environment details to target location."
conda env export > target_conda_environment_location"/conda_environment.yml"
pip freeze > target_conda_environment_location"/python_requirements.txt"

echo "removing environment variables"
unset jupyter_custom_kernel_path
unset jupyter_custom_kernel_name
unset jupyter_custom_kernel_version