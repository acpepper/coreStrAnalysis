#!/bin/bash

#SBATCH --mail-user=acpepper@ucdavis.edu #email this user
#SBATCH --mail-type=BEGIN #mail at beginning of run
#SBATCH --mail-type=END #mail at end of run
#SBATCH -p high2
#SBATCH -t 20000 # minutes
#SBATCH -J M1.05_L2.7 #name of job
#SBATCH -n 24 #number of cores
##SBATCH -w c7-13
#SBATCH -o stdout.txt
#SBATCH -e stderr.txt
#SBATCH --mem=124000

#ulimit -l unlimited

mpirun -np 24 mpicth i=default_name.in > runlog.txt
