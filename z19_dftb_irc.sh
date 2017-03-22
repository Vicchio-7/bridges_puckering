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
tpl=${p2}/puckering/y_tpl/3_dftb_tpl
dftb_files=${p2}/puckering/x_dftb_files
dftb_ending=${dftb_files}/list_dftb_files.txt

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

if [ "${molecule_type}" == 'oxane' ] ; then

    if [ "${job_type}" == 'irc' ] ; then
        echo "Currently missing!" #####################################################
    else
        echo ""
        echo "The type of job you are attemping to run is not recognized."
        echo ""
        echo "Running your job will fail."
    fi


elif [ "${molecule_type}" == 'bxyl' ] ;  then

    if [ "${job_type}" == 'irc' ] ; then
        echo "Currently missing!" #####################################################
    elif [ "${job_type}" == 'norm' ] ; then
        echo "Currently missing!" #####################################################
    else
        echo ""
        echo "The type of job you are attemping to run is not recognized."
        echo ""
        echo "Running your job will fail."
    fi

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


    level_theory=$(z02_level_replace_script.sh ${molecule_type} ${level_short})

    if [ ${level_short} == 'ERROR' ] ; then
        echo ''
        echo 'The level of theory being studied is not found in z02_level_replace_script.sh'
        echo ''
        echo 'Please add the correct level of theory before restarting'
        echo ''
        break
    fi

    irc_forward=${p1}/puckering/${folder}/${1}-${2}_${3}-forward
    irc_backward=${p1}/puckering/${folder}/${1}-${2}_${3}-reverse

    if [ ! -d ${irc_forward} ]; then
        mkdir ${irc_forward}
    fi

    if [ ! -d ${irc_backward} ]; then
        mkdir ${irc_backward}
    fi

    if [ ${molecule_type} == "oxane" ] ; then

        irc_file_list=${p2}/puckering/z_results/${folder}/${level_short}/z_cluster-sorted-TS-${molecule_type}-${level_short}.csv
        input_list=$( column -t -s ',' ${irc_file_list} | awk '{print $1}' )

    else

        irc_file_list=${p2}/puckering/z_results/${folder}/${level_short}/z_cluster_ring_pucker-sorted-TS-${molecule_type}-${level_short}.csv
        input_list=$( column -t -s ',' ${irc_file_list} | awk '{print $1}' )

    fi

     for file in ${input_list}; do

        file1=${file%.log\"}
        file2=${file1%.log}
        file_org=${file2##\"}

        if [ ${molecule_type} == "oxane" ] ; then
            old_check_file=${file_org}
        else
            old_check_file=${file_org%-norm_${level_short}}.chk
        fi

            if [ "${file_org}" != "File" ]; then

                echo ${file_org}

            fi
         done



fi