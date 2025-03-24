#!/bin/bash
#SBATCH --time=30:00
#SBATCH --ntasks=2
#SBATCH --mem=8G

# Load required modules
module load StdEnv/2020 gcc/7.3.0
module load r/4.0.2

cd /project/paria/2020/MR/MV_MR

# Run the R script
Rscript 4_Multivaliable_MR.R
