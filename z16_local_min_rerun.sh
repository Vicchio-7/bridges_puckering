#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script performs IRC calculations based on the output TS structures from hartree and xyz_cluster
#
# The code is divided into a few section; if you are not Stephen Vicchio, please be sure
# to change the '## Input - Command Line ##' options (first section below).

# --------------------------------------------------------------------------------------

## Input - Command Line ##
# The following information is needed from the command line

molecule_type=$1
job_type=$2
level_short=$3

## Input - Gaussian Run Information ##
# The following information determines the numbers of cores and memory the jobs will require.
cores_per_node=1
memory_job=3800
hours=30 #1, 2 ,3 ..... 10, 11, 12....
minutes=01 # number between 0 and 59

total_memory=$(echo ${cores_per_node} ${memory_job} | awk '{ print $1*$2 }' )

## Input - Codes ##
# Please update the following input commands depending on the user.

account=ct560hp
user=vicchio

## Additional Required Information ##
# Additional information such as folder location that is required for the code to run properly.

p1=/pylon5/${account}/${user}
p2=/pylon2/${account}/${user}
folder_type=4_opt_localmin
tpl=${p2}/puckering/y_tpl

# --------------------------------------------------------------------------------------

## Setup Check ##
if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
	tpl_folder=1_oxane_tpl
	status_build=0
elif [ "${molecule_type}" == 'bxyl' ] ;  then
	folder=2_bxyl
	tpl_folder=2_bxyl_tpl
	status_build=0
elif [ "${molecule_type}" == 'bglc' ] ;  then
	folder=3_betagluc
	tpl_folder=2_bxyl_tpl
	status_build=0
else
	echo
	echo "The molecule type is not found in this script"
	echo
	status_build=1
fi

# --------------------------------------------------------------------------------------

if [ ${status_build} == 1 ] ; then
	exit
elif [ ${status_build} == 0 ] ; then

    level_theory=$(z02_level_replace_script.sh ${molecule_type} ${level_short})

    if [ ${level_short} == 'ERROR' ] ; then
        echo ''
        echo 'The level of theory being studied is not found in z02_level_replace_script.sh'
        echo ''
        echo 'Please add the correct level of theory before restarting'
        echo ''
        break
    fi

    new_folder=11_re-opt_lm

    if [ ! -d ${p2}/puckering/${folder}/${level_short}/${new_folder}/ ]; then
        mkdir
    fi





fi

