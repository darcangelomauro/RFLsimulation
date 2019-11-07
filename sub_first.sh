#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50m
#SBATCH --time=10:00:00

# Load modules
module load armadillo-uon/intel2017
module load gsl-uon/intel2017

# Enter main directory
cd /gpfs01/home/pmxmd10/RFLmain/simulation

# Start simulation
./first $SEED_LVL1 $G2 $WORK_DIR
