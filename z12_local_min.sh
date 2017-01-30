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

## Input - Gaussian Run Information ##
# The following information determines the numbers of cores and memory the jobs will require.
cores_per_node=1
memory_job=15
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

# --------------------------------------------------------------------------------------

## Setup Check ##
if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
	tpl_folder=1_oxane_tpl
	status_build=0
	input_list=../y0-input_list.txt
elif [ "${molecule_type}" == 'bxyl' ] ;  then
	folder=2_bxyl
	tpl_folder=2_bxyl_tpl
	status_build=0
else
	echo
	echo "The molecule type is not found in this script"
	echo
	status_build=1
fi


# --------------------------------------------------------------------------------------

## Main Code ##

if [ ${status_build} == 1 ] ; then
	exit
elif [ ${status_build} == 0 ] ; then

    directory=${p2}/puckering/${folder}/${level_short}

    dir_job=${directory}/${folder_type}

    if [ ${molecule_type} == "oxane" ] ; then

        for file_unedit in $( <$input_list); do

            file=${file_unedit%.com}

            tpl_file=${tpl}/${tpl_folder}/run_oxane_optall-to-localmin.tpl

        ######## The section below updates the Gaussian Input File

            sed -e "s/\$memory/${total_memory}/g" ${tpl_file} > temp1.temp
            sed -e "s/\$num_procs/${cores_per_node}/g" temp1.temp >> temp2.temp
            sed -e "s/\$folder_1/${folder}/g" temp2.temp >> temp3.temp
            sed -e "s/\$folder_old/${molecule_type}-freeze_${level_short}/g" temp3.temp >> temp4.temp
            sed -e "s/\$old_check/${molecule_type}-${file}-freeze_${level_short}.chk/g" temp4.temp >> temp5.temp
            sed -e "s/\$folder_new/${molecule_type}-optall_${level_short}/g" temp5.temp >> temp6.temp
            sed -e "s/\$chkfile/${molecule_type}-${file}-freeze_${level_short}-${job_type}_${level_short}.chk/g" temp6.temp >> temp7.temp

            mv temp7.temp ${file}.com
            rm *.temp

        ######## The section below creates the Slurm file for submission on Bridges

            sed -e "s/\$num_proc/${cores_per_node}/g" ${tpl}/gaussian_slurm_script.job > temp1.txt
            sed -e "s/conform/${file}/g" temp1.txt >> temp2.txt
            sed -e "s/gauss-log/${1}-${file}-freeze_${3}-${2}_${3}/g" temp2.txt >> temp3.txt
            sed -e "s/$molecule/${molecule_type}/g" temp3.txt >> temp4.txt
            sed -e "s/$test/${job_type}/g" temp4.txt >> temp5.txt
            sed -e "s/$level/${level_short}/g" temp5.txt >> temp6.txt

            mv temp6.txt slurm-${file}.job
            rm temp*.txt

        done
    fi
fi