# Load required libraries
library(ggplot2)
library(dplyr)
library(MRPRESSO)
library(TwoSampleMR)
library(readr) 
library(MRInstruments)

# Define exposure and outcome files
id_exposure <- c("UC.txt", "CD.txt")
id_outcome <- "ALS.txt"

# Read exposure data (UC and CD)
exposure_dat <- mv_extract_exposures_local(
  id_exposure, sep ="\t", snp_col ="SNP", beta_col ="b", se_col ="StdErr",
  eaf_col ="EAF", effect_allele_col ="A1", other_allele_col ="A2", 
  pval_col ="p", ncase_col ="N_cases", ncontrol_col ="N_controls",
  samplesize_col ="SampleSize", log_pval =FALSE, min_pval =1e-200, 
  pval_threshold =5e-08, clump_r2 =0.001, clump_kb =10000, 
  harmonise_strictness =2, phenotype_col = "phenotype"
)

# Read outcome data (ALS)
outcome_dat <- read_outcome_data(
  snps = exposure_dat$SNP, filename = id_outcome, sep ="\t",
  snp_col ="SNP", beta_col ="b", se_col ="StdErr", eaf_col ="EAF",
  effect_allele_col ="A1", other_allele_col ="A2", pval_col ="p",
  samplesize_col ="SampleSize"
)

# Harmonise exposure and outcome data
mvdat <- mv_harmonise_data(exposure_dat, outcome_dat)

# Run multivariable MR
res <- mv_multiple(mvdat)

# Save MR results
write.csv(res, file="res.csv", quote=FALSE)

# Format and clean up results for easy reading
result_2smr <- res$result %>%
  separate(outcome, into = c("outcome", "extra"), sep = "[(]", extra = "drop") %>%
  mutate(outcome = stringr::str_trim(outcome)) %>%
  generate_odds_ratios() 

# Save the cleaned results
write.csv(result_2smr, file="res_cleaned.csv", quote=FALSE)

sessionInfo()