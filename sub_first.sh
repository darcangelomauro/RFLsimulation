#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50m
#SBATCH --time=20:00:00


# Enter main directory
cd /gpfs01/home/pmxmd10/RFLmain/simulation


# Load modules
module load armadillo-uon/intel2017/9.500.2
module load gsl-uon/intel2017/2.5

echo $SEED_LVL1 $G2 $WORK_DIR

# Start simulation
./first $SEED_LVL1 $G2 $WORK_DIR
