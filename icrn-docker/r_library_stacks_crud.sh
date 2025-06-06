#!/bin/bash

# This script is used to edit the .Renviron file to add the ICRN library path
# It is used to add the ICRN library path to the .Renviron file

# env vars assumed to exist:
# ICRN_LIBRARY_BASE # user's location for the base of ICRN library structure
# ICRN_ENVIRONMENTS_BASE
# ICRN_LIBRARY_REPOSITORY
# ICRN_LIBRARY_REPOSITORY/templates/user_catalogue.json
# ex: ~{HOME}/.icrn/r_libraries/
# ICRN_LIBRARY_BASE/library_catalogue.json
# ICRN_LIBRARY_BASE/libraries/
# ICRN_LIBRARY_BASE/libraries/<library_name> -> link-to-R-lib-loc-within-environment
# environments:
# ~{HOME}/.icrn/environments/<library_name>/etc/R/library


# number_packages=$(jq -r '.channels.manual | length' $json_tags)
# echo "found $number_packages to iterate through"
# for package_i in `seq 0 $(($number_packages - 1))`; do
#   tag=$(jq -r ".channels.$channel.[$package_i].tag" $json_tags)
#   url=$(jq -r ".channels.$channel.[$package_i].url" $json_tags)

available() {

}

list() {
    user_catalogue=${ICRN_LIBRARY_BASE}/library_catalogue.json
    echo "checked out libraries:"
    echo $(jq -r '. | keys[]' $user_catalogue)
}

get() {
    # if library does not exist in user catalogue
    # detarball the tarball from central repo
    # activate conda env
    # unpack conda env
    # get conda R path
    # update registry
    # deactivate cond env
}

update() {
    # get version from user's catalogue
    # compare version with central catalogue
    # if central > user
    # remove user
    # get central
}

remove() {
    # check for existence of library in user catalogue
    # 
}

init() {
    # check for existence of ~{HOME}/.icrn/
    # check for environment variables
        # if not set:
        # set:
    # check for user library catalogue
        # if file exists, do nothing, else, get it
}

libraries() {
    local cmdname=$1; shift
    if type $cmdname > /dev/null 2>&1; then
    fi
}

[[ $_ != $0 ]] && return

# check for existence of needed tools
if [ -z jq ]; then
    echo "Need tool jq installed to proceed."
    exit 1
fi

# make sure we actually *did* get passed a valid function name
if declare -f "$1" >/dev/null 2>&1; then
  # invoke that function, passing arguments through
  "$@" # same as "$1" "$2" "$3" ... for full argument list
else
  echo "Function $1 not recognized" >&2
  exit 1
fi