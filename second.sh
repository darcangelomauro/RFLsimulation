#!/bin/bash

# Check that level 0 seed has been passed as argument
if [ -z "$1" ]
then
	echo "Need to pass level 0 seed"
	return
fi

# Check that work directory has been passed as argument
if [ -z "$2" ]
then
	echo "Need to pass directory name"
	return
fi

# Check that the work directory actually exists
if [ ! -d $2 ]
then
	echo "Directory doesn't exist"
	return
fi

# Define some variables
SEED_LVL0=$1
HERE=$PWD
PATH_MAIN=$HERE/../RFLmain
WORK_PATH=$HERE/$2
INIT_FILE=$WORK_PATH/init.txt
G2_FILE=$WORK_PATH/g2_val.txt
JOB_FILE=$WORK_PATH/job_idx.txt

# Check that init file actually exists
if [ ! -f $INIT_FILE ]
then
	echo "Init file doesn't exist"
	return
fi

# Check that g2 file actually exists
if [ ! -f $G2_FILE ]
then
	echo "g2 file doesn't exist"
	return
fi

# Check that job index file actually exists
if [ ! -f $JOB_FILE ]
then
	echo "job index file doesn't exist"
	return
fi

# Read how many g2 values will be simulated
G2_NUM=0
while read -r
do
	G2_NUM=$((G2_NUM+1))
done < $G2_FILE

# Read how many jobs will be submitted for each g2 value
JOB_NUM=0
while read -r
do
	JOB_NUM=$((JOB_NUM+1))
done < $JOB_FILE


# Cycle on g2 values
COUNTER=0
while read -r G2_VAL
do
	# Create g2 directory name
	G2_STRING=$(echo "$G2_VAL" | tr - n | tr . d)
	
	# Cycle on job array indices and create a comma-separated string from them
	JOB_STRING= 
	while read -r JOB_IDX
        do
		JOB_STRING+="$JOB_IDX,"
        done < $JOB_FILE
	JOB_STRING=${JOB_STRING%?}

	# Compute Level 1 seed
	SEED_LVL1=$((SEED_LVL0+COUNTER*JOB_NUM))
	
	# Submit job array
	sbatch --array=$JOB_STRING --export=SEED_LVL1=$SEED_LVL1,G2=$G2_VAL,WORK_PATH=$WORK_PATH sub_second.sh

	# Increment counter
	COUNTER=$((COUNTER+1))
done < $G2_FILE





