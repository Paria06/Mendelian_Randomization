# Load required libraries
library(ggplot2)
library(dplyr)
library(MRPRESSO)
library(TwoSampleMR)
library(readr)

# Define the base directory where dataset folders are stored
base_dir <- "/project/paria/2020/MR/MR_significantMR/"

# Recursively find all mr_results.rds files in subdirectories
sig_files <- list.files(base_dir, pattern="mr_results.rds$", recursive=TRUE, full.names=TRUE)

# Extract the parent directory for each file
parent_dirs <- dirname(sig_files)

# Loop through each found file
for (file_path in sig_files) {
  
  # Get the folder where the file is located
  folder <- dirname(file_path)
  
  # Read the data
  sig <- readRDS(file_path)
  
  # Ensure output directory exists
  if (!dir.exists(folder)) {
    dir.create(folder, recursive=TRUE, showWarnings=FALSE)
  }
  
  # Generate MR report
  mr_report(sig, study = basename(folder), output_path = folder)
  
  # Scatter plot
  res <- mr(sig)
  p1 <- mr_scatter_plot(res, sig)
  ggsave(p1[[1]], file = file.path(folder, "scatter_plot.jpg"), width = 5, height = 5)
  
  # Leave-one-out plot
  res_loo <- mr_leaveoneout(sig)
  p3 <- mr_leaveoneout_plot(res_loo)
  ggsave(p3[[1]], file = file.path(folder, "loo_plot.jpg"), width = 10, height = 10)
  
  # Funnel plot
  res_single <- mr_singlesnp(sig)
  p4 <- mr_funnel_plot(res_single)
  ggsave(p4[[1]], file = file.path(folder, "funnel_plot.jpg"), width = 5, height = 5)
  
  # Forest plot
  p5 <- mr_forest_plot(res_single)
  ggsave(p5[[1]], file = file.path(folder, "forest_plot.jpg"), width = 5, height = 5)
}

sessionInfo()
