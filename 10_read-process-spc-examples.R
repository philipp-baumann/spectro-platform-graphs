## Load packages
library("tidyverse")
library("simplerspec")

# List of Bruker OPUS files from Bruker NIR or mid-IR spectrometer
lf <- dir("data/spectra/soil-mir-examples", full.names = TRUE)

# Read spectra and metadata from OPUS files into a list in R
spc_list <- read_opus_univ(fnames = lf, extract = c("spc"))

## Spectral data processing pipe ===============================================

spc_tbl <- spc_list %>%
  # Convert nested list into tibble
  gather_spc() %>%
  # Standardize spectra to equal x unit intervals, 2cm^{-1} resolution
  resample_spc(wn_lower = 500, wn_upper = 3996, wn_interval = 2) %>%
  # Calculate mean spectra by `sample_id` column
  average_spc(by = "sample_id") %>%
  # Savitzky-Golay 1st derivative, window size of 21 points (2cm^{-1} * 21)
  preprocess_spc(select = "sg_1_w21")