#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script generates Gaussian Input and Slurm files for running jobs with the ring
# atoms frozen.
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
hours=2 #1, 2 ,3 ..... 10, 11, 12....
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
folder_type=2_freeze
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
	input_list=../y0-input_list.txt
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

    if [ ! -d ${p1}/puckering/${folder}/${molecule_type}-optall_${level_short} ]; then
        mkdir ${p1}/puckering/${folder}/${molecule_type}-optall_${level_short}
    fi

    if [ ${molecule_type} == "oxane" ] ; then

        for file_unedit in $( <$input_list); do

            file=${file_unedit%.com}

            tpl_file=${tpl}/${tpl_folder}/run_oxane_freeze.tpl

        ######## The section below updates the Gaussian Input File

            head -n 4 ${tpl_file} >> temp1.temp
            tail -n 22 ../0_initial-coordinates/${file}.com >> temp1.temp

            sed -e "s/\$memory/${total_memory}/g" temp1.temp >> temp2.temp
            sed -e "s/\$num_procs/${cores_per_node}/g" temp2.temp >> temp3.temp
            sed -e "s/\$folder_1/${folder}/g" temp3.temp >> temp4.temp
            sed -e "s/\$folder_new/${molecule_type}-optall_${level_short}/g"  temp4.temp >> temp5.temp
            sed -e "s/\$chkfile/${molecule_type}-${file}-freeze_${level_short}.chk/g"  temp5.temp >> temp6.temp
            sed -e "s/\level_of_theory/${level_theory}/g" temp6.temp >> temp7.temp

            mv temp7.temp ${file}.com
            rm *.temp


        ######## The section below creates the Slurm file for submission on Bridges

            sed -e "s/\$num_proc/${cores_per_node}/g" ${tpl}/gaussian_slurm_script.job > temp1.txt
            sed -e "s/conform/${file}/g" temp1.txt >> temp2.txt
            sed -e "s/gauss-log/${1}-${file}-freeze_${3}/g" temp2.txt >> temp3.txt
            sed -e "s/\$molecule/${molecule_type}/g" temp3.txt >> temp4.txt
            sed -e "s/\$test/${job_type}/g" temp4.txt >> temp5.txt
            sed -e "s/\$level/${level_short}/g" temp5.txt >> temp6.txt
            sed -e "s/\$hours/${hours}/g" temp6.txt >> temp7.txt
            sed -e "s/\$minutes/${minutes}/g" temp7.txt >> temp8.txt

            mv temp8.txt slurm-${file}.job
            rm temp*.txt
        done
    fi
fi