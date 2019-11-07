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
PATH_RFL=$HERE/../RFL
WORK_PATH=$HERE/$2
INIT_FILE=$WORK_PATH/init.txt
G2_FILE=$WORK_PATH/g2_val.txt
JOB_FILE=$WORK_PATH/job_idx.txt
LOG_FILE=$WORK_PATH/$2.log

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



# Create log file in work directory containing
# all necessary data to replicate simulation
cd $PATH_RFL
HASH_RFL=`git rev-parse HEAD`
cd $PATH_MAIN
HASH_MAIN=`git rev-parse HEAD`
cd $HERE
echo -n "RFL git hash: " > $LOG_FILE
echo $HASH_RFL >> $LOG_FILE
echo -n "RFLmain git hash: " >> $LOG_FILE
echo $HASH_MAIN >> $LOG_FILE
echo -n "Level 0 seed: " >> $LOG_FILE
echo $SEED_LVL0 >> $LOG_FILE
cat $INIT_FILE >> $LOG_FILE 
echo -n "Number of g2 values: " >> $LOG_FILE
echo $G2_NUM >> $LOG_FILE
echo -n "Number of jobs per g2 value: " >> $LOG_FILE
echo $JOB_NUM >> $LOG_FILE
echo -ne "g2 values: \n" >> $LOG_FILE
cat $G2_FILE >> $LOG_FILE 
echo -ne "Job array indices: \n" >> $LOG_FILE
cat $JOB_FILE >> $LOG_FILE 



# Cycle on g2 values
COUNTER=0
while read -r G2_VAL
do
	# Create g2 directory
	G2_STRING=$(echo "$G2_VAL" | tr - n | tr . d)
	mkdir $WORK_PATH/$G2_STRING
	
	# Cycle on job array indices
	while read -r JOB_IDX
        do
		# Create all job array directories
                mkdir $WORK_PATH/$G2_STRING/$JOB_IDX
        done < $JOB_FILE

	# Compute Level 1 seed
	SEED_LVL1=$((SEED_LVL0+COUNTER*JOB_NUM))
	
	# Submit job
	sbatch --export=SEED=$SEED_LVL1,G2=$G2_VAL,WORK_PATH=$WORK_PATH sub_first.sh

	# Increment counter
	COUNTER=$((COUNTER+1))
done < $G2_FILE





