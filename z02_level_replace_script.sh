#!/usr/bin/env bash

# Created by: Stephen P. Vicchio

# This script replaces inputs the short level of theory, and replaces it with the formal,
# long, name level of theory.
#
# Example: input: B3LYP --> output: B3lYP/6-311+(g,p)
#
# The code is divided into a few section; if you are not Stephen Vicchio, please be sure
# to change the '## Input - Command Line ##' options (first section below).

# --------------------------------------------------------------------------------------

## Input - Command Line ##
# The following information is needed from the command line

molecule_type=$1
level_short=$2

## Setup Check ##
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

# --------------------------------------------------------------------------------------

## Main Code ##

if [ ${status_build} == 1 ]; then
	exit
elif [ ${status_build} == 0 ] ; then

    if [ ${level_short} == 'am1' ] ; then

        echo 'am1'

    elif [ ${level_short} == 'b3lyp' ] ; then
        echo 'b3lyp\/6-31+G(d,p)'
    elif [ ${level_short} == 'pm3' ] ; then
        echo 'pm3'
    elif [ ${level_short} == 'dftb' ] ; then
        echo 'dftb'
    elif [ ${level_short} == 'APFD' ] ; then
        echo 'APFD\/6-31+G(d,p)'
    else
        echo "# # # ERROR # # #"
    fi

fi
