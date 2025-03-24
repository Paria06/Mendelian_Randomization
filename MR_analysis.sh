#!/bin/bash
#SBATCH --time=9-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=8G


module load nixpkgs/16.09 gcc/7.3.0
module load r/4.0.2
# Define the root directory where all subfolders are located
BASE_DIR="/project/paria/2020/MR/MR_significant"

# Define dataset names (same as subfolder names)
datasets=("ALS" "Asthma" "CD" "CeD" "IBD" "MS" "PBC" "PSC" "PSo" "RA" "SLE" "T1D" "UC")
# Loop through each dataset folder
for dataset in "${datasets[@]}"; do
    # Construct the full path to the clumped file
    FILE_PATH="$BASE_DIR/$dataset/${dataset}_clumped.txt"
    
    # Run R script inside Singularity container for each dataset
    singularity exec -B ~/runs/:/project ~/runs/eyu8/soft/TwoSampleMR.sif Rscript 2_MR_analysis.R "$FILE_PATH" "$dataset"
done