#!/bin/bash
#SBATCH --time=45:00
#SBATCH --mem=4G


# Load required modules
module load singularity/3.7
cd /home/paria/runs/paria/MR

# Create directories for each dataset
for N in ALS Asthma CD CeD IBD MS_1 MS_2 PBC_1 PBC_2 PSC PSo RA SLE T1D_1 T1D_3 T1D_4 UC; do 
    mkdir -p "$N"
done

# Run the R script inside the Singularity container
singularity exec -B ~/runs/:/project ~/runs/eyu8/soft/TwoSampleMR.sif Rscript 1_Clumping_significant_SNPs.R
