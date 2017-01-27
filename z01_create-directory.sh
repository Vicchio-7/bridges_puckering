#!/usr/bin/env bash
echo
echo 'This script will create the necessary folder for my jobs!'
echo

# Created by: Stephen P. Vicchio

# This script creates the correct production for a given level of theory


molecule_type=$1
level_short=$2

if [ "${molecule_type}" == 'oxane' ] ; then
	folder=1_oxane
	status_build=0
elif [ "${molecule_type}" == 'bxyl' ] ;  then
	folder=2_bxyl
	status_build=0
else
	echo
	echo "The molecule type is not found in this script"
	echo
	status_build=1
fi

if [ ${status_build} == 1 ]; then
	exit
elif [ ${status_build} == 0 ] ; then
    echo 'Ready to rumble!'
fi

