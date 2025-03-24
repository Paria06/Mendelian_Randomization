# Load required libraries
require(TwoSampleMR)
library(ggplot2)
library(dplyr)
library(MRPRESSO)

# Get file path and dataset name from shell script arguments
args <- commandArgs(trailingOnly=TRUE)
clumped_file <- args[1]  # Full path to clumped file
dataset_name <- args[2]  # Dataset name (ALS, CeD, IBD, etc.)

# Read exposure data
exp_data <- read_exposure_data(
  clumped_file, sep="\t", snp_col = "SNP", beta_col = "beta.exposure",  
  eaf_col = "eaf.exposure", se_col="se.exposure", effect_allele_col = "effect_allele.exposure",
  other_allele_col= "other_allele.exposure", pval_col = "pval.exposure", 
  ncase_col= "ncase.exposure", ncontrol_col="ncontrol.exposure", 
  samplesize_col = "N.exposure", clump=FALSE
)

# Read outcome data
out_data <- read_outcome_data(
  snps = exp_data$SNP, filename = "ALS.txt", sep="\t", snp_col = "SNP", 
  beta_col = "b", se_col = "StdErr", eaf_col = "EAF", effect_allele_col = "A1", 
  other_allele_col = "A2", pval_col = "p", ncase_col = "N_cases", 
  ncontrol_col = "N_controls", samplesize_col="SampleSize"
)

out_data$r.outcome <- get_r_from_lor(
  out_data$beta.outcome, out_data$eaf.outcome, out_data$ncase.outcome, 
  out_data$ncontrol.outcome, 0.01, model = "logit"
)

dat <- harmonise_data(exposure_dat=exp_data, outcome_dat=out_data, action=2)

# Steiger filtering
dat$units.outcome <- "log odds"
dat$units.exposure <- "log odds"
dat1 <- subset(dat, dat$eaf.exposure != "NA")
dat1$r.exposure <- get_r_from_lor(dat1$beta.exposure, dat1$eaf.exposure, 
                                  dat1$ncase.exposure, dat1$ncontrol.exposure, 
                                  0.1, model = "logit")

steiger <- steiger_filtering(dat1)
sig <- subset(steiger, steiger$steiger_dir == TRUE)

# MR PRESSO to detect horizontal pleiotropy
presso <- mr_presso(
  BetaOutcome = "beta.outcome", BetaExposure = "beta.exposure",
  SdOutcome = "se.outcome", SdExposure = "se.exposure", OUTLIERtest = TRUE,
  DISTORTIONtest = TRUE, data= sig, NbDistribution = 1000, SignifThreshold = 0.05
)

capture.output(print(presso), file = paste0(dataset_name, "/presso.txt"))

# Perform MR analysis
result <- mr(sig)
saveRDS(result, file = paste0(dataset_name, "/mr_results.rds"))

# Calculate average R2 and F-statistics
R2 <- mean(sig$r.exposure)
n <- mean(sig$samplesize.exposure)
k <- nrow(subset(sig, sig$ambiguous == FALSE))

capture.output(print(R2), file = paste0(dataset_name, "/r2.txt"))
F <- (R2 * (n - 1 - k)) / ((1 - R2) * k)
capture.output(print(F), file = paste0(dataset_name, "/f.txt"))

# Generate MR report
mr_report(sig, study = dataset_name, output_path = dataset_name)
res_single <- mr_singlesnp(sig)
p5 <- mr_forest_plot(res_single)

# Save the forest plot
ggsave(p5[[1]], file = "plot.jpg", path = dataset_name, width = 7, height = 12)

sessionInfo()