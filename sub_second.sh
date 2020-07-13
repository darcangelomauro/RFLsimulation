#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=100m
#SBATCH --time=150:00:00

# Load modules
module load armadillo-uon/intel2017
module load gsl-uon/intel2017

# Enter main directory
cd /gpfs01/home/pmxmd10/RFLmain/simulation

# Start simulation
SEED=$((SEED_LVL1 + SLURM_ARRAY_TASK_ID))
echo $SEED $G2 $WORK_PATH $SLURM_ARRAY_TASK_ID
./second $SEED $G2 $WORK_PATH $SLURM_ARRAY_TASK_ID
echo "node: "
echo $SLURMD_NODENAME
