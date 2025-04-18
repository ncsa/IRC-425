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

if [[ -z "${icrn_environments_path}" ]]; then
  echo ERROR: Environment variable unset: icrn_environments_path
  return 1
fi

working_directory="./Recipes"
json_tags="$working_directory/recipe_tags.json"

# create the subdirs, get the git repos, add them as submodules if needed, checkout branches
for dir in $(jq -r 'keys_unsorted[]' $json_tags); do
  if [ "$dir" == "$jupyter_custom_kernel_name" ]; then
    continue
  fi
  tag=$(jq -r ".\"$dir\".tag" $json_tags)
  url=$(jq -r ".\"$dir\".url" $json_tags)
  resourcePath=$(jq -r ".\"$dir\".resourcePath" $json_tags)
  type=$(jq -r ".\"$dir\".type" $json_tags)
  target_dir=$working_directory"/"$dir

  # git submodule handling: add or checkout correct tag
  if [ "$type" == "recipe" ]; then
    echo "obtaining $dir as custom recipe"
    if [ ! -d $target_dir ]; then
      echo "[$dir] missing submodule"
      git submodule add $url $target_dir
    fi
    git submodule update --init --recursive $target_dir
    cd $target_dir || return
    # e.g. cd Recipes/ePhotosynthesis_C/
    if ! [ "$tag" == "none" ]; then
      git checkout $tag || return
    fi
    cd $icrn_base_working_dir || return
  elif [ "$type" == "package" ]; then
    echo "obtaining $dir as prebuilt package"
    if [ ! -d $target_dir ]; then
      echo "[$dir] missing for prebuilt package"
      mkdir -p $target_dir || return
      cd $target_dir || return
      wget $url || return
      # local path is now $target_dir/<tarball file>    # <---- weak
      cd $icrn_base_working_dir || return
    fi
  fi
done

echo "Done: retrieving remote resources."
