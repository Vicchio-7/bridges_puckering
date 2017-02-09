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
	input_list=../y0-input_list.txt
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

    if [ ${molecule} == "oxane" ] ; then

    ts_hartree_file=${p2}/z_results/${folder}/${level_short}/z_cluster_sorted-TS-${molecule_type}-${level_short}.csv
    input_list=$( column -t -s ',' ${ts_hartree_file} | awk '{print $1}' )

    for file in ${input_list}; do

        file1=${file%.log\"}
        file_org=${file1##\"}

            if [ "${file_org}" != "File" ]; then

                echo ${file_org}

                ##### IRC - Forward Direction! #####

                new_filenamef=${file_org}-ircf
                old_check_file=${file_org}.chk
                new_check_file=${new_filenamef}_${3}.chk

                sed -e "s/\$memory/${total_memory}/g" ${tpl}/${tpl_folder}/run_irc_forward.tpl > temp1.com
                sed -i "s/\$num_procs/${cores_per_node}/g" temp1.com
                sed -i "s/\$folder_old/${1}-TS_${3}/g" temp1.com
                sed -i "s/\$old_check/${file_org}.chk/g" temp1.com
                sed -i "s/\$chkfile/${new_check_file}/g" temp1.com
                sed -i "s/\$folder/${molecule}-${test_type}_${3}-forward/g" temp1.com
                sed -i "s/level_of_theory/${level_of_theory}/g" temp1.com

                mv temp1.com ${new_filenamef}.com

                ######## The section below creates the Slurm file for submission on Bridges
                sed -e "s/\$num_proc/${cores_per_node}/g" ${tpl}/gaussian_slurm_script.job > temp1.txt
                sed -i "s/conform/${file}/g" temp1.txt
                sed -i "s/gauss-log/${file}-freeze_${3}-${2}_${3}/g" temp1.txt
                sed -i "s/\$molecule/${molecule_type}/g" temp1.txt
                sed -i "s/\$test/${job_type}/g" temp1.txt
                sed -i "s/\$level/${level_short}/g" temp1.txt
                sed -i "s/\$hours/${hours}/g" temp1.txt
                sed -i "s/\$minutes/${minutes}/g" temp1.txt

                mv temp1.txt slurm-${new_filenamef}.job

             fi
         done
    fi
fi