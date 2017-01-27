#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script creates the correct production for a given level of theory on PSC Bridges.

# --------------------------------------------------------------------------------------

## Input - Command Line ##

# The following information is needed from the command line

molecule_type=$1
level_short=$2

## Input - Codes ##

# Please update the following input commands depending on the user.

account=ct560hp
user=vicchio

p1=/pylon1/${account}/${user}
p2=/pylon2/${account}/${user}

## Main Code ##

if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
	status_build=0
elif [ "${molecule_type}" == 'bxyl' ] ;  then
	folder=2_bxyl
	status_build=0
else
	echo
	echo "The molecule type is not found in this script"
	echo
	status_build=1
fi

if [ ${status_build} == 1 ]; then
	exit
elif [ ${status_build} == 0 ] ; then
    echo 'Ready to rumble!'

    directory=${p2}/${folder}/${level_short}

    if [ -d ${directory} ] ; then
		echo
		echo "This directory already exists for ${level_of_theory_short} in ${folder}..."
		echo
	else
	    mkdir $directory


fi

