#!/usr/bin/env bash

# Created by: Stephen P. Vicchio
#
# This script submits all slurm files in a directory for rapid submission on PSC.
#

# --------------------------------------------------------------------------------------

## Input - Command Line ##
# The following information is needed from the command line

run_type=$1
keyword=$2

# --------------------------------------------------------------------------------------

## Main Code ##

for file_sub in $(find . \( ! -name . -prune \) -type f -iname 'slurm-*.job'); do
		sbatch ${file_sub}
done

