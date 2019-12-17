## Load packages
library("tidyverse")
library("here")
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

## Plot spectra at various processing stages ===================================

p_spc <-
  spc_tbl %>%
  mutate(
    label = "example spectra"
  ) %>%
  plot_spc_ext(
    spc_tbl = .,
    lcols_spc = c("spc", "spc_mean", "spc_pre"),
    group_id = "label",
    line_width = 0.4
  )

ggsave(filename = "spc-proc-example.pdf", plot = p_spc,
  path = here("out", "figs"), width = 5, height = 5)
ggsave(filename = "spc-proc-example.png", plot = p_spc,
  path = here("out", "figs"), width = 5, height = 5)
