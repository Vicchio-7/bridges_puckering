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

p1=/pylon5/${account}/${user}
p2=/pylon2/${account}/${user}
tpl=${p2}/puckering/y_tpl/4_dftb_tpl_updated
dftb_files=${p2}/puckering/x_dftb_files
dftb_ending=${dftb_files}/list_dftb_files.txt

# --------------------------------------------------------------------------------------

## Setup Check ##

if [ "${molecule_type}" == 'bglc' ] ;  then
	folder=3_bglc
	status_build=0
	input_list=../y0-input_list.txt
	ext=.xyz
else
	echo
	echo "The molecule type is not found in this script"
	echo
	status_build=1
fi

# --------------------------------------------------------------------------------------

## Special DFTB Identification Step ##

if [ "${molecule_type}" == 'bglc' ] ;  then
    if [ "${job_type}" == 'freeze' ] ; then
        template=bglc_freeze.tpl
        folder_type=2_freeze
    elif [ "${job_type}" == 'optall' ] ; then
        template=run_oxane_optall-to-localmin.tpl
    elif [ "${job_type}" == 'TS' ] ; then
        template=run_oxane_optall-to-TS.tpl
    elif [ "${job_type}" == 'init' ] ; then
        template=bglc_init.tpl
    elif [ "${job_type}" == 'irc' ] ; then
        echo "Currently missing!" #####################################################
    elif [ "${job_type}" == 'lmirc' ] ; then
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

    directory=${p2}/puckering/${folder}/${level_short}
    dir_job=${directory}/${folder_type}
    if [ ! -d ${p1}/puckering/${folder}/${molecule_type}-${job_type}_${level_short} ]; then
        mkdir ${p1}/puckering/${folder}/${molecule_type}-${job_type}_${level_short}
    fi

    tpl_file=${tpl}/${template}

    for file_unedit in $( <$input_list); do
        file=${file_unedit%.xyz}

        if [ "${job_type}" == 'freeze' ] ; then
            echo ${file}

            sed -e "s/\$memory/${total_memory}/g" ${tpl_file} > ${file}.com
            sed -i "s/\$num_procs/${cores_per_node}/g" ${file}.com
            sed -i "s/\$folder_1/${folder}/g" ${file}.com
            sed -i "s/\$old_check/${file}-init_${level_short}.chk/g" ${file}.com
            sed -i "s/\$folder_new/${molecule_type}-${job_type}_${level_short}/g" ${file}.com
            sed -i "s/\$chkfile/${file}-${job_type}_${level_short}.chk/g" ${file}.com


        elif [ "${job_type}" == 'init' ] ; then
            echo ${file}

            head -n 8 ${tpl_file} > ${file}.com

            tail -n 22 ../0_initial-coordinates/${file}.xyz >> ${file}.com

            sed -i "s/\$memory/${total_memory}/g" ${file}.com
            sed -i "s/\$num_procs/${cores_per_node}/g" ${file}.com
            sed -i "s/\$structure/${file}/g" ${file}.com
            sed -i "s/\$folder_1/${folder}/g" ${file}.com
            sed -i "s/\$folder_new/${molecule_type}-${job_type}_${level_short}/g" ${file}.com
            sed -i "s/\$chkfile/${file}-${job_type}_${level_short}.chk/g" ${file}.com


        elif [ "${job_type}" == 'optall' ] ; then
            echo ${file}

        elif [ "${job_type}" == 'TS' ] ; then
            echo ${file}

        fi

    done
fi