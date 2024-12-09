#!/bin/bash

# shamelessly lifted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh

# requiring the kernel name to also be the directory name as well as in the tags isn't the most robust method
custom_kernel="IRC425"
custom_kernel_path="./Kernels/"$custom_kernel

sed -i~ -e '/^## Current Release/,$d' README.md
echo "## Current Release" >> README.md
echo "" >> README.md
echo "This is the list of releases for $custom_kernel $(jq -r ."[$custom_kernel]" tags.json)" >> README.md
echo "" >> README.md
echo "| module | version |" >> README.md
echo "| ------ | ------- |" >> README.md

# TODO: this will update all submodules in the repo - not just for this custom kernel
git submodule update --remote
for dir in $(jq -r 'keys[]' $custom_kernel_path"/"tags.json | sort); do
  if [ "$dir" == "$custom_kernel" ]; then continue; fi
  tag=$(jq -r ".\"$dir\"" tags.json)
  if [ "$tag" == "null" ]; then
    echo "[$dir] missing tag"
  else
    if [ ! -d $dir ]; then
      echo "[$dir] missing submodule"
      git submodule add https://github.com/IN-CORE/$dir $dir
    fi
    echo "[$dir] checking out $tag"
    sed -i~ "s/^| $dir | .* |$/| $dir | $tag |/" README.md
    rm README.md~
    (cd $dir; git checkout $tag)
    git add $dir
  fi
  echo "| ${dir} | ${tag} |" >> README.md
done

git add README.md tags.json
git submodule status
git status