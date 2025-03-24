#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --ntasks=2
#SBATCH --mem=8G

# Load required modules
module load StdEnv/2020 gcc/7.3.0
module load r/4.0.2

cd /project/paria/2020/MR/visualization

library(data.table)


Rscript 3_MR_visualization.R