#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --ntasks=2
#SBATCH --mem=8G

# Load required modules
module load StdEnv/2020 gcc/7.3.0
module load r/4.0.2

cd /project/paria/2020/MR/Liftover

# This tutorial was used: https://genome.ucsc.edu/FAQ/FAQdownloads.html#snp
# The dataset for the liftover was downloaded from this link: http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg19ToHg38.over.chain.gz
# The liftover tool was downloaded from this link: https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver

library(data.table)
#Note: the number of chromosome in chr column should be this format chrX not X


wget http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg19ToHg38.over.chain.gz

# final command
# the four columns are chromosome, position1, position2, and rsID  repectively
./liftOver preLift.bed hg19ToHg38.over.chain.gz conversions.bed unMapped

# successful conversions in "conversions.bed" and unsuccessful conversions in "unMapped"

