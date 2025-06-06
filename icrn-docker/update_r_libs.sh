#!/bin/bash

# This script is used to edit the .Renviron file to add the ICRN library path
# It is used to add the ICRN library path to the .Renviron file

# Get the ICRN library path from the command line - this is passed from the calling method
# usage therefore is: ./update_r_libs.sh target_renviron_path target_library_name

target_Renviron_file=$1
target_library_name=$2

if [ -z "$target_Renviron_file" ]; then
    echo "no target Renviron file specified."
    exit 1
fi

# for dev: set the ICRN library base path; this should be done inside of the dockerfile in prod
export ICRN_LIBRARY_BASE=${HOME}/.icrn/icrn_libraries


update_r_libs_path()
{
    target_r_environ_file=$1
    icrn_library_name=$2
    ICRN_library_path=${ICRN_LIBRARY_BASE}/${icrn_library_name}
    echo "# ICRN ADDITIONS - do not edit" >> $target_r_environ_file
    if [ -z "$icrn_library_name" ]; then
        echo "R_LIBS="'${R_LIBS:-}' >> $target_r_environ_file
    else
        echo "R_LIBS="${ICRN_library_path}':${R_LIBS:-}' >> $target_r_environ_file
    fi
}

if [ ! -z $target_Renviron_file ]; then
    if [ -e $target_Renviron_file ]; then
        if [ ! -z "$(grep "# ICRN ADDITIONS - do not edit" $target_Renviron_file)" ]; then
            sed -i '/^# ICRN ADDITIONS - do not edit$/,$d' $target_Renviron_file 
        fi
    fi
    update_r_libs_path $target_Renviron_file $target_library_name
fi