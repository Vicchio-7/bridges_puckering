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
	input_list=../y0-input_list.txt
	ext=.com
elif [ "${molecule_type}" == 'bxyl' ] ;  then
	folder=2_bxyl
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

if [ "${molecule_type}" == 'oxane' ] ; then

    if [ "${job_type}" == 'freeze' ] ; then
        template=run_oxane_freeze.tpl
        folder_type=2_freeze
    elif [ "${job_type}" == 'optall' ] ; then
        template=run_oxane_optall-to-localmin.tpl
    elif [ "${job_type}" == 'TS' ] ; then
        template=run_oxane_optall-to-TS.tpl
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

elif [ "${molecule_type}" == 'bxyl' ] ;  then
    echo
    echo "Need to add bxyl information to scripts...." #####################################################
    echo
    status_build=1
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

    if [ ${molecule_type} == "oxane" ] ; then

       for file_unedit in $( <$input_list); do

            file=${file_unedit%.com}

       if [ "${job_type}" == 'freeze' ] ; then

            tpl_file=${tpl}/${template}

        ######## The section below updates the Gaussian Input File

            head -n 4 ${tpl_file} >> temp1.temp
            tail -n 22 ../0_initial-coordinates/${file}.com >> temp1.temp

            sed -i "s/\$memory/${total_memory}/g" temp1.temp
            sed -i "s/\$num_procs/${cores_per_node}/g" temp1.temp
            sed -i "s/\$folder_1/${folder}/g" temp1.temp
            sed -i "s/\$folder_new/${molecule_type}-freeze_${level_short}/g"  temp1.temp
            sed -i "s/\$chkfile/${molecule_type}-${file}-freeze_${level_short}.chk/g"  temp1.temp
            sed -i "s/\level_of_theory/${level_theory}/g" temp1.temp

            mv temp1.temp ${file}.com

            sed -i '$d' ${file}.com
            sed -i '$s/$/\nD   1    2    3    4 F/' ${file}.com
            sed -i '$s/$/\nD   2    3    4    5 F/' ${file}.com
            sed -i '$s/$/\nD   3    4    5    6 F/' ${file}.com
            sed -i '$s/$/\nD   4    5    6    1 F/' ${file}.com
            sed -i '$s/$/\nD   5    6    1    2 F/' ${file}.com
            sed -i '$s/$/\nD   6    1    2    3 F/' ${file}.com
            sed -i '$s/$/\n/' ${file}.com

            cat ${dftb_ending} >> ${file}.com

            sed -i '$s/$/\n/' ${file}.com
            sed -i '$s/$/\n/' ${file}.com


       elif [ "${job_type}" == 'optall' ] ; then

            tpl_file=${tpl}/${template}

        ######## The section below updates the Gaussian Input File

            sed -e "s/\$memory/${total_memory}/g" ${tpl_file} > temp1.temp
            sed -i "s/\$num_procs/${cores_per_node}/g" temp1.temp
            sed -i "s/\$folder_1/${folder}/g" temp1.temp
            sed -i "s/\$folder_old/${molecule_type}-freeze_${level_short}/g" temp1.temp
            sed -i "s/\$old_check/${molecule_type}-${file}-freeze_${level_short}.chk/g" temp1.temp
            sed -i "s/\$folder_new/${molecule_type}-optall_${level_short}/g" temp1.temp
            sed -i "s/\$chkfile/${molecule_type}-${file}-freeze_${level_short}-${job_type}_${level_short}.chk/g" temp1.temp
            sed -i "s/\level_of_theory/${level_theory}/g" temp1.temp

            mv temp1.temp ${file}.com

            sed -i '$d' ${file}.com

            cat ${dftb_ending} >> ${file}.com

            sed -i '$s/$/\n/' ${file}.com
            sed -i '$s/$/\n/' ${file}.com


       else
            echo ""
            echo "The type of job you are attemping to run is not recognized."
            echo ""
            echo "Running your job will fail."
       fi


        ######## The section below creates the Slurm file for submission on Bridges

            sed -e "s/\$num_proc/${cores_per_node}/g" ${tpl}/../gaussian_slurm_script.job > temp1.txt
            sed -i "s/conform/${file}/g" temp1.txt
            sed -i "s/gauss-log/${1}-${file}-freeze_${3}/g" temp1.txt
            sed -i "s/\$molecule/${molecule_type}/g" temp1.txt
            sed -i "s/\$test/${job_type}/g" temp1.txt
            sed -i "s/\$level/${level_short}/g" temp1.txt
            sed -i "s/\$hours/${hours}/g" temp1.txt
            sed -i "s/\$minutes/${minutes}/g" temp1.txt

            mv temp1.txt slurm-${file}.job
       done
    fi
fi