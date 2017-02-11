#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script runs performs Norm in Gaussian09. Running norm reveals the dihedral ring
# contributions for the imaginary frequency to find ring puckering transition states.
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
minutes=10 # number between 0 and 59

total_memory=$(echo ${cores_per_node} ${memory_job} | awk '{ print $1*$2 }' )

## Input - Codes ##
# Please update the following input commands depending on the user.

account=ct560hp
user=vicchio

## Additional Required Information ##
# Additional information such as folder location that is required for the code to run properly.

p1=/pylon1/${account}/${user}
p2=/pylon2/${account}/${user}
folder_type=5_opt_TS
tpl=${p2}/puckering/y_tpl
results_location=${p2}/puckering/z_results

# --------------------------------------------------------------------------------------

## Setup Check ##
if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
	tpl_folder=1_oxane_tpl
	status_build=
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

    level_theory=$(z02_level_replace_script.sh ${molecule_type} ${level_short})

    if [ ${level_short} == '# # # ERROR # # #' ] ; then
        echo ''
        echo 'The level of theory being studied is not found in z02_level_replace_script.sh'
        echo ''
        echo 'Please add the correct level of theory before restarting'
        echo ''
        break
    fi

    # Finding the hartree file to perform norm analysis on

    ts_hartree_file=../5_opt_TS/z_hartree-unsorted-TS-${molecule_type}-${level_short}.csv

    echo ${ts_hartree_file}

    input_list=$( column -t -s ',' ${ts_hartree_file} | awk '{print $1}' )

    if [ ! -d ${p1}/puckering/${folder}/${molecule_type}-norm_${level_short} ]; then
        mkdir ${p1}/puckering/${folder}/${molecule_type}-norm_${level_short}
    fi

    echo ${input_list}

    for file_unedit in ${input_list}; do
#
        file1=${file%.log\"}
        file_org=${file1##\"}

        echo ${file_org}
#            tpl_file=${tpl}/${tpl_folder}/run_norm.tpl
#
#        ######## The section below updates the Gaussian Input File
#
##            sed -e "s/\$memory/${total_memory}/g" ${tpl_file} > temp1.temp
##            sed -e "s/\$num_procs/${cores_per_node}/g" temp1.temp >> temp2.temp
##            sed -e "s/\$folder_1/${folder}/g" temp2.temp >> temp3.temp
##            sed -e "s/\$folder_old/${molecule_type}-freeze_${level_short}/g" temp3.temp >> temp4.temp
##            sed -e "s/\$old_check/${molecule_type}-${file}-freeze_${level_short}.chk/g" temp4.temp >> temp5.temp
##            sed -e "s/\$folder_new/${molecule_type}-TS_${level_short}/g" temp5.temp >> temp6.temp
##            sed -e "s/\$chkfile/${molecule_type}-${file}-freeze_${level_short}-${job_type}_${level_short}.chk/g" temp6.temp >> temp7.temp
##            sed -e "s/\level_of_theory/${level_theory}/g" temp7.temp >> temp8.temp
##
##            mv temp8.temp ${file}.com
##            rm *.temp
#
#        ######## The section below creates the Slurm file for submission on Bridges
#
##            sed -e "s/\$num_proc/${cores_per_node}/g" ${tpl}/gaussian_slurm_script.job > temp1.txt
##            sed -e "s/conform/${file}/g" temp1.txt >> temp2.txt
##            sed -e "s/gauss-log/${1}-${file}-freeze_${3}-${2}_${3}/g" temp2.txt >> temp3.txt
##            sed -e "s/\$molecule/${molecule_type}/g" temp3.txt >> temp4.txt
##            sed -e "s/\$test/${job_type}/g" temp4.txt >> temp5.txt
##            sed -e "s/\$level/${level_short}/g" temp5.txt >> temp6.txt
##            sed -e "s/\$hours/${hours}/g" temp6.txt >> temp7.txt
##            sed -e "s/\$minutes/${minutes}/g" temp7.txt >> temp8.txt
##
##            mv temp8.txt slurm-${file}.job
##            rm temp*.txt
    done
fi