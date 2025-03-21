#!/bin/bash

# multiple environment variables are assumed to exist when this script is invoked
# executing this script in a standalone fashion will not be successful at this time.

working_directory="./Kernels/"$jupyter_custom_kernel_name
json_tags="$working_directory/environment_tags.json"

kernel_display_name=$(jq -r ".kernel_display_name" $json_tags)
kernel_install_name=$(jq -r ".kernel_install_name" $json_tags)
kernel_install_version=$(jq -r ".kernel_version" $json_tags)
kernel_is_latest=$(jq -r ".is_latest" $json_tags)
echo "kernel_install_name: "$kernel_install_name
echo "kernel_display_name: "$kernel_display_name
echo "kernel_install_version: "$kernel_install_version
echo "kernel_is_latest: "$kernel_is_latest


# only auto-magically install if we're running as prod.
if [ "$icrn_runtime_context" == "Prod" ]; then
  echo "Runtime context found to be: Prod"
#  jupyter_ipykernel_name="$jupyter_custom_kernel_name-$jupyter_custom_kernel_version"
  echo "starting ipykernel installation as: "$kernel_install_name
  echo "with display name: "$kernel_display_name
  echo "version is: "$kernel_install_version
  if [ "$kernel_is_latest" == "TRUE" ]; then
    echo "This is the latest version."
  else
    echo "this is not the latest version"
  fi

  # install this kernel as this version - regardless of if it is latest or not
  if python -m ipykernel install --user --name $kernel_install_name --display-name="$kernel_display_name"
  then
    echo "Kernel installation successful"
  else
    echo "Error during kernel installation."
    return
  fi

  # install this kernel as latest, if it is latest.
  if [ "$kernel_is_latest" == "TRUE" ]; then
    if python -m ipykernel install --user --name $kernel_install_name"-latest" --display-name="$kernel_display_name""-latest"
    then
      echo "Kernel installation as 'latest' successful"
    else
      echo "Error during kernel installation as 'latest'."
      return
    fi
  else
    echo "this is not the latest version - not attempting install as latest."
  fi
  jupyter kernelspec list
else
  echo "Not running in prod - will not install into jupyter at this time."
  echo "install command: "
  echo "python -m ipykernel install --user --name $kernel_install_name --display-name=$kernel_display_name"
fi