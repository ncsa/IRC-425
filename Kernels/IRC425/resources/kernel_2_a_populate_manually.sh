#!/bin/bash

# shamelessly lifted from INCORE: https://github.com/IN-CORE/IN-CORE/blob/main/update.sh

# multiple environment variables are assumed to exist when this script is invoked
# executing this script in a standalone fashion will not be successful at this time.

# create the subdirs, get the git repos, add them as submodules if needed, checkout branches
echo "beginning manual installs (run via shell scripts locally, rather than via a package manager)..."
channel="manual"
number_packages=$(jq -r '.channels.manual | length' $json_tags)
echo "found $number_packages to iterate through"
for package_i in `seq 0 $(($number_packages - 1))`; do
  tag=$(jq -r ".channels.$channel.[$package_i].tag" $json_tags)
  url=$(jq -r ".channels.$channel.[$package_i].url" $json_tags)
  install_script=$(jq -r ".channels.$channel.[$package_i].install" $json_tags)
  package_name=$(jq -r ".channels.$channel.[$package_i].name" $json_tags)
  target_dir=$working_directory""$package_name
  echo "| ${package_name} | ${tag} |"
  # submodule handling: add or checkout correct tag
  if [ "$tag" == "null" ]; then
    echo "[$package_name] missing tag. Cannot continue."
    return 1
  else
    if [ ! -d $target_dir ]; then
      echo "[$package_name] missing submodule"
      if [ "$icrn_runtime_context" == "dryrun" ]; then
        echo "Dryrun: "
        echo 'git submodule add '$url $target_dir
      else
        git submodule add $url $target_dir
      fi
    fi
    if [ "$icrn_runtime_context" == "dryrun" ]; then
        echo "Dryrun: "
        echo 'git submodule update --init --recursive '$target_dir
        echo "[$package_name] checking out $tag"
        echo "current dir: ${PWD}"
        echo "would change via: cd $target_dir"
        echo "git checkout $tag "
        echo "cd ../../../"
        echo "triggering install of $package_name"
        # not invoking manual install scripts as part of dryrun
        echo "warning: will not invoke manual install scripts as part of dryrun. ensure you test these."
        echo 'source '$working_directory'resources/'$install_script
    else
      git submodule update --init --recursive $target_dir
      echo "[$package_name] checking out $tag"
      echo "current dir: ${PWD}"
      cd $target_dir || return
      echo "current dir: ${PWD}"
      git checkout $tag || return
      echo "current dir: ${PWD}"
      cd ../../../
      echo "current dir: ${PWD}"

      echo "triggering install of $package_name"
      source $working_directory"resources/"$install_script

      echo "done with: "$tag
    fi
  fi
done
#
#echo "triggering install processes"
#source $working_directory"/kernel_3_install.sh"
echo "done with manual installs"
echo ""
echo ""
