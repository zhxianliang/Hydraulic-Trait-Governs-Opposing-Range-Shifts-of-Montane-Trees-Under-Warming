
# Load required packages
library(ggplot2)   # plotting
library(reshape2)  # data reshaping (not used here but kept if needed later)
library(openxlsx)  # read Excel files

# Clear workspace
rm(list = ls())

# Read data from Excel (Sheet 2 contains climate rate data)
rate <- read.xlsx("D:\\ITRDB_5000\\Mountain_site\\data\\fig.S7_climate_rate", sheet = 2)

# Create plot: warming rate vs shift rate
ggplot(rate, aes(x = tem_b * 10, y = shift)) +   # tem_b*10 converts to °C per decade
  
  # Scatter points (each point = species or population)
  geom_point(size = 2) +
  
  # Fit regression line (GLM; can switch to 'lm' if linear model preferred)
  geom_smooth(method = 'glm', se = TRUE) +
  
  # Axis labels with units (standard scientific format)
  xlab('Warming rate (°C decade⁻¹)') +
  ylab('Shift rate (m year⁻¹)') +
  
  # Classic black-and-white theme (journal-friendly)
  theme_bw() +
  
  # Improve readability
  theme(
    axis.title = element_text(size = 12),  # axis titles
    axis.text = element_text(size = 10)    # axis tick labels
  )
# Save figure (TIFF format for publication)
ggsave(
  "D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_rate_4_13.tiff",
  width = 6,
  height = 5,
  dpi = 300
)
