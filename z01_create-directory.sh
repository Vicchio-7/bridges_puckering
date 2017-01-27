#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script creates the correct production for a given level of theory on PSC Bridges.
# The code is divided into a few section; if you are not Stephen Vicchio, please be sure
# to change the '## Input - Command Line ##' options (first section below).

# --------------------------------------------------------------------------------------

## Input - Command Line ##
# The following information is needed from the command line

molecule_type=$1
level_short=$2

## Input - Codes ##
# Please update the following input commands depending on the user.

account=ct560hp
user=vicchio

## Additional Required Information ##
# Additional information such as folder location that is required for the code to run properly.

tpl=${p2}/y_template_files
p1=/pylon1/${account}/${user}
p2=/pylon2/${account}/${user}

# --------------------------------------------------------------------------------------

## Setup Check ##
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

# --------------------------------------------------------------------------------------

## Main Code ##

if [ ${status_build} == 1 ]; then
	exit
elif [ ${status_build} == 0 ] ; then
    echo 'Ready to rumble!'

    directory=${p2}/puckering/${folder}/${level_short}

    if [ -d ${directory} ] ; then
		echo
		echo "This directory already exists for ${level_of_theory_short} in ${folder}..."
		echo
	else
	    echo
	    echo "The following directory is being made for $level_short in $molecule_type"
	    echo

	    mkdir $directory

	    cd ${directory}

	    mkdir 0_initial-coordinates
	    mkdir 1_sample-files
	    mkdir 2__freeze
	    mkdir 3_relax-freeze_run
	    mkdir 4_opt_localmin
	    mkdir 5_opt_TS
	    mkdir 6_norm_analysis
	    mkdir 7_irc_run
		mkdir 8_irc_localmin

    fi


    raw_coords=${p2}/puckering/${folder}/z_folder_raw-coordinates

    echo $raw_coords
    echo "hi there"

fi

