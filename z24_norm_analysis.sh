#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script performs the local min optimization for the
#
# The code is divided into a few section; if you are not Stephen Vicchio, please be sure
# to change the '## Input - Command Line ##' options (first section below).

# --------------------------------------------------------------------------------------

## Input - Command Line ##
# The following information is needed from the command line

molecule_type=$1
job_type=$2
level_short=$3


## Input - xyz_cluster ##
# If you need to change the tolerance, please check the ## Setup Check ## section

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
results_location=${p2}/puckering/z_results
failure=out-failure-${1}-${2}-${3}.status

# --------------------------------------------------------------------------------------

## Setup Check ##
if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
    tol=0.1
	status_build=0
elif [ "${molecule_type}" == 'bxyl' ] ;  then
	folder=2_bxyl
	ring_atoms='1,5,8,9,13,17'
	tol=0.1
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

    z04_check_normal_termination.sh ${molecule_type} TS ${level_short}

    if [ ! -f ${failure} ]; then
        echo "No Files failed!"
        echo
        echo "Please wait a few minutes...."
        echo


    hartree norm -d ../6_norm_analysis/. -o ../6_norm_analysis

    ls *norm.txt > z_list_norm_files.txt

    norm_analysis -s z_list_norm_files.txt -r ${ring_atoms}

    mv z_norm-analysis_TS_exo_puckers_z_list_norm_files.txt z_norm-analysis_TS_exo_puckers.txt
    mv z_norm-analysis_TS_ring_puckers_z_list_norm_files.txt z_norm-analysis_TS_ring_puckers



    cp z_norm-analysis_TS_exo_puckers.txt ${results_location}/${folder}/${level_short}/.
    cp z_norm-analysis_TS_ring_puckers.txt ${results_location}/${folder}/${level_short}/.

    fi
fi