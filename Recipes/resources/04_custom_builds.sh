#!/bin/bash

# shamelessly lifted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh
echo ""
echo "######### Beginnning builds of custom packages ##########"
echo ""

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


# create the subdirs, get the git repos, add them as submodules if needed, checkout branches
for dir in $(jq -r 'keys_unsorted[]' $json_tags); do
  if [ "$dir" == "$jupyter_custom_kernel_name" ]; then continue; fi
  tag=$(jq -r ".\"$dir\".tag" $json_tags)
  url=$(jq -r ".\"$dir\".url" $json_tags)
  resourcePath=$(jq -r ".\"$dir\".resourcePath" $json_tags)
  type=$(jq -r ".\"$dir\".type" $json_tags)
  target_dir=$working_directory"/"$dir
  full_resource_path=$target_dir"/"$resourcePath
  # git submodule handling: add or checkout correct tag
  if [ "$type" == "recipe" ]; then
    echo "$dir is a custom recipe..."
    echo "custom recipe location: $full_resource_path"
#    echo "target location: $icrn_prebuilt_recipes_path"
#    mkdir -p $icrn_prebuilt_recipes_path"/$dir" || return 1
#    grayskull pypi --output $icrn_prebuilt_recipes_path"/$dir" $resourcePath  || return 1
#    echo "grayskull complete for $dir"
    echo "invoking conda-build for $full_resource_path"
    conda_build_command="conda-build --channel conda-forge --use-local --override-channels --no-anaconda-upload --quiet --output-folder $icrn_custom_channel_path $full_resource_path"
    echo $conda_build_command
    conda-build --channel conda-forge --use-local --override-channels --no-anaconda-upload --quiet --output-folder $icrn_custom_channel_path $full_resource_path || return 1
    echo "conda build done."
  elif [ "$type" == "package" ]; then
    echo "$dir is a prebuilt package - doing nothing."

  fi
done
conda search --override-channels -c $icrn_custom_channel_path
echo "Done: retrieving remote resources."
