#!/bin/bash

# shamelessly lifted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh

# requiring the kernel name to also be the directory name as well as in the tags isn't the most robust method
#TODO: need to either put these in a config or environment vars - pasting at top of every sh is crap
custom_kernel="IRC425"
custom_kernel_path="./Kernels/$custom_kernel/"
json_tags="$custom_kernel_path""tags.json"
#sed -i~ -e '/^## Current Release/,$d' README.md
#echo "## Current Release" >> README.md
#echo "" >> README.md
#echo "This is the list of releases for $custom_kernel $(jq -r ."[$custom_kernel]" tags.json)" >> README.md
#echo "" >> README.md
#echo "| module | version |" >> README.md
#echo "| ------ | ------- |" >> README.md

source $custom_kernel_path"/kernel_prepare.sh"

git submodule update --init

for dir in $(jq -r 'keys[]' $json_tags | sort); do
  if [ "$dir" == "$custom_kernel" ]; then continue; fi
  tag=$(jq -r ".\"$dir\".tag" $json_tags)
  url=$(jq -r ".\"$dir\".url" $json_tags)
  install_script=$(jq -r ".\"$dir\".install" $json_tags)
  target_dir=$custom_kernel_path""$dir

  # submodule handling: add or checkout correct tag
  if [ "$tag" == "null" ]; then
    echo "[$dir] missing tag"
  else
    if [ ! -d $target_dir ]; then
      echo "[$dir] missing submodule"
      git submodule add $url $target_dir
    fi
    echo "[$dir] checking out $tag"
#    sed -i~ "s/^| $dir | .* |$/| $dir | $tag |/" README.md
#    rm README.md~
    (cd $target_dir; git checkout $tag)
    git add $target_dir
  fi
  echo "| ${dir} | ${tag} |"
#  echo "| ${dir} | ${tag} |" >> README.md
done

echo "triggering install processes"
source $custom_kernel_path"kernel_install.sh"
echo "done with installs"

echo "starting ipykernel installation"
python -m ipykernel install --user --name CustomKernel01 --display-name="CustomKernel01"
jupyter kernelspec list