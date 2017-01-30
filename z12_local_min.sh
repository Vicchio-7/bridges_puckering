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


## Input - Codes ##
# Please update the following input commands depending on the user.

account=ct560hp
user=vicchio

## Additional Required Information ##
# Additional information such as folder location that is required for the code to run properly.

tpl=${p2}/y_template_files
tpl_file=run_oxane_optall-to-localmin.tpl
p1=/pylon1/${account}/${user}
p2=/pylon2/${account}/${user}
folder_type=4_opt_localmin

# --------------------------------------------------------------------------------------

## Setup Check ##
if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
	tpl_folder=1_oxane_tpl
	status_build=0
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

if [ ${status_build} == 1 ]; then
	exit
elif [ ${status_build} == 0 ] ; then

    directory=${p2}/puckering/${folder}/${level_short}

    dir_job=${directory}/${folder_type}

    if [ ${molecule} == "oxane" ] ; then

        for file_unedit in $( <$input_list); do

            file=${file_unedit%.com}

            echo ${file}

#        ######## The section below updates the Gaussian Input File
#
#            sed -e "s/\$memory/${total_memory}/g" $tpl/${template_file_oxane} > temp1.com
#            sed -e "s/\$num_procs/${cores_per_node}/g" temp1.com >> temp2.com
#            sed -e "s/\$folder_old/${1}-freeze_${3}/g" temp2.com >> temp3.com
#            sed -e "s/\$old_check/${1}-${file}-freeze_${3}.chk/g" temp3.com >> temp4.com
#            sed -e "s/\$chkfile/${molecule}-${file}-freeze_${short_level_of_theory}-${test_type}_${short_level_of_theory}.chk/g" temp4.com >> temp5.com
#            sed -e "s/\$folder/${molecule}-${test_type}_${3}/g" temp5.com > temp6.com
#            sed -e "s/level_of_theory/${level_of_theory}/g" temp6.com >> temp7.com
#
#            mv temp7.com ${file}.com
#
#            rm temp*.com
#
#        ######## The section below creates the PBS file for submission on flux
#
#            sed -e "s/molecule/${molecule}/g" $tpl/gaussian-PBS-tpl.txt > temp1.txt
#            sed -e "s/study/${2}/g" temp1.txt >> temp2.txt
#            sed -e "s/level_of_theory_short/${short_level_of_theory}/g" temp2.txt >> temp3.txt
#            sed -e "s/conform/${file}/g" temp3.txt >> temp4.txt
#            sed -e "s/gauss-log/${1}-${file}-freeze_${3}-${2}_${3}/g" temp4.txt >> temp5.txt
#            sed -e "s/\$num_proc/${cores_per_node}/g" temp5.txt >> temp6.txt
#            sed -e "s/\$pmemory/${memory_job}/g" temp6.txt >> temp7.txt
#
#            mv temp7.txt PBS-${2}-${file}.txt
#
#            rm temp*.txt
        done

fi