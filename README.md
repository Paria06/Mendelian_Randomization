# Mendelian Randomization Analysis

## Overview

This repository contains the analysis pipeline for performing Mendelian Randomization (MR) using genetic instruments to investigate causal relationships between exposures and outcomes. The pipeline includes steps for SNP extraction, MR analysis, visualization, and multivariable MR to account for confounding factors.

## Manuscript

This analysis has been published in BMC Medicine. You can access the full manuscript here:
https://link.springer.com/article/10.1186/s12916-022-02578-9 

## Directory Structure

```plaintext
MR_Analysis_Workflow/
│
├── Step 1: SNP Extraction and Clumping
│   ├── Extract_significant_SNPs.sh
│   └── 1_Clumping_significant_SNPs.R
│
├── Step 2: GWAS Liftover (hg19 to hg38)
│   └── GWAS_liftover_hg19ToHg38.sh
│
├── Step 3: MR Analysis
│   ├── MR_analysis.sh
│   ├── 2_MR_analysis.R
│
├── Step 4: MR Visualization
│   ├── MR_visualization.sh
│   └── 3_MR_visualization.R
│
├── Step 5: Multivariable MR
│   ├── Multivariable_MR.sh
│   └── 4_Multivariable_MR.R
│
└── Step 6: Reporting and Documentation
    ├── README
    └── Documentation of the workflow and results

