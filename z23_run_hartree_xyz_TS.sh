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
        echo "No Files failed! Performing hartree and xyz_cluster"
        echo
        echo "Please wait a few minutes...."
        echo

        if [[ ${molecule_type} == 'oxane' ]]; then
            hartree cpsnap -d $PWD > z_hartree-unsorted-${job_type}-${molecule_type}-${level_short}.csv
            z05_grab_xyz_coords.sh ${molecule_type}
            xyz_cluster -s z_hartree-unsorted-${job_type}-${molecule_type}-${level_short}.csv -t ${tol}
            mv z_cluster_z_hartree-unsorted-${job_type}-${molecule_type}-${level_short}.csv z_cluster_sorted-${job_type}-${molecule_type}-${level_short}.csv
        elif [[ ${molecule_type} == 'bxyl' ]]; then
            echo 'hi mom'
        fi

    fi

    if [ ! -d ${results_location}/${folder}/${level_short}/ ]; then
        mkdir ${results_location}/${folder}/${level_short}/
    fi

    echo
    echo "Copying files over to:" ${results_location}/${folder}/${level_short}
    echo

    cp z_hartree-unsorted-${job_type}-${molecule_type}-${level_short}.csv ${results_location}/${folder}/${level_short}/z_hartree-unsorted-${job_type}-${molecule_type}-${level_short}.csv
    cp z_cluster_sorted-${job_type}-${molecule_type}-${level_short}.csv ${results_location}/${folder}/${level_short}/z_cluster_sorted-${job_type}-${molecule_type}-${level_short}.csv

    echo "Copied all log files to 10_ts_viz_logs"
    echo

    cp *.log ../10_ts_viz_logs/.

fi