#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script is designed to run DFTB methods on Gaussian09
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
hours=0 #1, 2 ,3 ..... 10, 11, 12....
minutes=45 # number between 0 and 59

total_memory=$(echo ${cores_per_node} ${memory_job} | awk '{ print $1*$2 }' )

## Input - Codes ##
# Please update the following input commands depending on the user.

account=ct560hp
user=vicchio

## Additional Required Information ##
# Additional information such as folder location that is required for the code to run properly.

p1=/pylon1/${account}/${user}
p2=/pylon2/${account}/${user}
folder_type=4_opt_localmin
tpl=${p2}/puckering/y_tpl
dftb_files=${p2}/puckering/x_dftb_files

# --------------------------------------------------------------------------------------

## Setup Check ##
if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
	status_build=0
	ext=.com
elif [ "${molecule_type}" == 'bxyl' ] ;  then
	folder=2_bxyl
	status_build=0
	ext=.xyz
else
	echo
	echo "The molecule type is not found in this script"
	echo
	status_build=1
fi

# --------------------------------------------------------------------------------------

## Special DFTB Identification Step ##

if [ "${job_type}" == 'freeze' ] ; then
    echo ${job_type}
elif [ "${job_type}" == 'optall' ] ; then
    echo ${job_type}
elif [ "${job_type}" == 'TS' ] ; then
    echo ${job_type}
elif [ "${job_type}" == 'irc' ] ; then
    echo ${job_type}
elif [ "${job_type}" == 'lmirc' ] ; then
    echo ${job_type}
else
    echo ""
    echo "The type of job you are attemping to run is not recognized."
    echo ""
    echo "Running your job will fail."
fi

