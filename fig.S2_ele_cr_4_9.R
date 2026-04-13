# Load required libraries
library(ggplot2)    # Plotting
library(reshape2)   # Data reshaping
library(openxlsx)   # Excel I/O
library(readxl)     # Excel reading

# Clear workspace
rm(list = ls())

# Read species and elevation data
specode <- read.csv("D:/ITRDB_5000/Mountain_site/data/fig.S1.S2.S4.S5_Mountain site.csv", header = TRUE)

# Extract unique species codes
spee <- unique(specode$specode)

# Initialize elevation vector
idx <- specode$elev

# Exclude species with fewer than 20 observations
for (i in 1:length(spee)) {
  speee <- spee[i]
  sss <- which(specode$specode == speee)
  len <- length(sss)
  
  if (len < 20) {
    idx[sss] <- NA
  }
}

# Identify valid (non-missing) observations
non_na_indexes <- which(!is.na(idx))

# Subset dataset to species with sufficient sample size
sped <- specode[non_na_indexes, ]

# Extract unique species–code combinations
speok <- sped[, c("species", "specode")]
speok <- speok[!duplicated(speok$species), ]

# Order species alphabetically (no taxonomic standardization applied)
speok <- speok[order(speok$species), ]

# Set factor levels for consistent facet ordering
sped$specode <- factor(sped$specode, levels = speok$specode)

#---------------------- Significance calculation ----------------------#

# Function to convert p-values to significance symbols
get_sig <- function(p) {
  if (is.na(p)) return("ns")
  if (p < 0.001) return("***")
  if (p < 0.01)  return("**")
  if (p < 0.05)  return("*")
  return("ns")
}

# Function to calculate correlation p-value between elevation and a variable
get_cor_p <- function(dat, yvar) {
  x <- dat$elev
  y <- dat[[yvar]]
  ok <- complete.cases(x, y)
  
  if (sum(ok) < 3) return(NA)
  out <- try(cor.test(x[ok], y[ok]), silent = TRUE)
  if (inherits(out, "try-error")) return(NA)
  return(out$p.value)
}

# Split dataset by species
splist <- split(sped, sped$specode)

# Compute significance labels for each species
sig_df <- do.call(rbind, lapply(names(splist), function(sp) {
  dat <- splist[[sp]]
  
  p_pdsi <- get_cor_p(dat, "pdsycr")
  p_temp <- get_cor_p(dat, "temcr")
  p_prec <- get_cor_p(dat, "precr")
  
  data.frame(
    specode = sp,
    x = 200,     # x-position for annotation
    y1 = 0.90,   # y-positions for three lines
    y2 = 0.75,
    y3 = 0.60,
    lab1 = paste0("PDSI: ", get_sig(p_pdsi)),
    lab2 = paste0("Temp: ", get_sig(p_temp)),
    lab3 = paste0("Prec: ", get_sig(p_prec))
  )
}))

# Ensure consistent factor levels
sig_df$specode <- factor(sig_df$specode, levels = levels(sped$specode))

#---------------------- Plotting ----------------------#

p <- ggplot() +
  
  # PDSI correlation
  geom_point(data = sped, aes(elev, pdsycr), color = "red", na.rm = TRUE, size = 0.8) +
  geom_smooth(data = sped, aes(elev, pdsycr), method = "lm", se = FALSE,
              color = "red", linewidth = 0.4) +
  
  # Temperature correlation
  geom_point(data = sped, aes(elev, temcr), color = "forestgreen", na.rm = TRUE, size = 0.8) +
  geom_smooth(data = sped, aes(elev, temcr), method = "lm", se = FALSE,
              color = "forestgreen", linewidth = 0.4) +
  
  # Precipitation correlation
  geom_point(data = sped, aes(elev, precr), color = "blue", na.rm = TRUE, size = 0.8) +
  geom_smooth(data = sped, aes(elev, precr), method = "lm", se = FALSE,
              color = "blue", linewidth = 0.4) +
  
  # Add significance annotations
  geom_text(data = sig_df, aes(x = x, y = y1, label = lab1),
            color = "red", size = 2.5, hjust = 0) +
  geom_text(data = sig_df, aes(x = x, y = y2, label = lab2),
            color = "forestgreen", size = 2.5, hjust = 0) +
  geom_text(data = sig_df, aes(x = x, y = y3, label = lab3),
            color = "blue", size = 2.5, hjust = 0) +
  
  # Axis limits and layout
  xlim(0, 4000) +
  ylim(-1, 1) +
  facet_wrap(~specode, nrow = 5) +
  
  # Labels
  ylab("Correlation") +
  xlab("Elevation (m)") +
  
  # Theme settings
  theme_bw() +
  theme(
    strip.text = element_text(size = 8),
    axis.text = element_text(size = 7),
    axis.title = element_text(size = 10)
  )

# Display plot
p

# Save figure
ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_species_elev_cr1.tiff",
       plot = p, width = 12, height = 10, dpi = 300)