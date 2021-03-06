#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=100m
#SBATCH --time=60:00:00


# Enter main directory
cd /gpfs01/home/pmxmd10/RFLmain/simulation


# Load modules
module load armadillo-uon/intel2017/9.500.2
module load gsl-uon/intel2017/2.5

echo $SEED $G2 $WORK_PATH

# Start simulation
./first $SEED $G2 $WORK_PATH
echo "node: "
echo $SLURMD_NODENAME
