#!/bin/bash

# multiple environment variables are assumed to exist when this script is invoked
# executing this script in a standalone fashion will not be successful at this time.

# create the subdirs, get the git repos, add them as submodules if needed, checkout branches
echo "Beginning to process channels & packages..."
for channel in $(jq -r '.channels | keys[]' $json_tags); do
  echo "processing channel: "$channel
  if [ "$channel" == "manual" ]; then
    source $working_directory"/kernel_resources/kernel_2_a_populate_manually.sh"
  else
    if [ "$channel" == "ICRN_NCSA_Custom_Channel" ]; then
      this_channel=$icrn_custom_channel_path
    else
      this_channel=$channel
    fi
    package_array=$(jq -r ".channels.\"$channel\"" $json_tags)
    array_length=$(jq 'length' <<< "$package_array")
    package_listing=""
    for i in $(seq 0 $(($array_length - 1))); do
      package_name=$(jq -r ".[$i].name" <<< "$package_array")
      package_version=$(jq -r ".[$i].version" <<< "$package_array")
      if [ "$package_name" == "null" ]; then
        echo "a package has a missing name in json definitions within $channel channel."
        return 1
      elif [ "$package_version" == "null" ]; then
        echo "a package has a missing version in json definitions within $channel channel."
        return 1
      else
        # build out list of packages - running in a single conda cmd is more robust (length warning?)
        package_listing="${package_listing} ${package_name}${package_version}"
      fi
    done
    # install this thing from the right channel
    # conda behaves better when these are all done in one command
    # consider running checks for existence of package in channel. conda will throw errors if it can't be found...
    if [ "$package_listing" != "" ]; then
      if [ "$icrn_runtime_context" == "dryrun" ]; then
        echo "Dryrun: "
        echo 'conda install --solver=libmamba -y '${package_listing}
      else
        echo 'conda install --solver=libmamba -y '${package_listing}
        conda install --solver=libmamba -y ${package_listing} || return 1
      fi
    else
      echo 'no packages for '$this_channel
      echo ""
    fi
  fi

done
