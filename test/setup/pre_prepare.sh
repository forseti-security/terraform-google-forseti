#!/bin/bash

# shellcheck disable=SC2018
project_suffix="$(LC_ALL=C tr -dc 'a-z' < /dev/urandom | fold -w 4 | head -n 1)"
echo -e "project_suffix=\"$project_suffix\" \n"  > terraform.tfvars
