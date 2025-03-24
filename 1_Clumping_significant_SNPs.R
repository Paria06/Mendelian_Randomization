# Clumping step should not be run in interactive node
# Load required library for Mendelian Randomization analysis
require(TwoSampleMR)

# Define a vector of file paths for significant MR results of various conditions
file <- c(
  "/project/paria/2020/MR/MR_significant/ALS_sig.txt",
  "/project/paria/2020/MR/MR_significant/Asthma_sig.txt",
  "/project/paria/2020/MR/MR_significant/CD_sig.txt",
  "/project/paria/2020/MR/MR_significant/CeD_sig.txt",
  "/project/paria/2020/MR/MR_significant/IBD_sig.txt",
  "/project/paria/2020/MR/MR_significant/MS_sig.txt",
  "/project/paria/2020/MR/MR_significant/PBC_sig.txt",
  "/project/paria/2020/MR/MR_significant/PSC_sig.txt",
  "/project/paria/2020/MR/MR_significant/PSo_sig.txt",
  "/project/paria/2020/MR/MR_significant/RA_sig.txt",
  "/project/paria/2020/MR/MR_significant/SLE_sig.txt",
  "/project/paria/2020/MR/MR_significant/T1D_sig.txt",
  "/project/paria/2020/MR/MR_significant/UC_sig.txt"
)

# Define a vector of folder names corresponding to each condition
folder <- c("ALS", "Asthma", "CD", "CeD", "IBD", "MS", "PBC", "PSC", "PSo", "RA", "SLE", "T1D", "UC")
for(i in 1:length(file)) {
  
  # Read exposure data from the specified file with appropriate column specifications
  exp_data <- read_exposure_data(
    file[i], sep="\t", snp_col="SNP", beta_col="b", eaf_col="EAF",
    se_col="StdErr", effect_allele_col="A1", other_allele_col="A2", 
    pval_col="p", samplesize_col="SampleSize", 
    ncase_col="N_cases", ncontrol_col="N_controls", clump=TRUE
  )
  
  # Write the clumped exposure data to a new text file in the corresponding folder
  write.table(exp_data, file=paste0("/project/paria/2020/MR/MR_significant/", folder[i], "/clumped.txt"), row.names=FALSE, quote=FALSE, sep="\t")
}

sessionInfo()