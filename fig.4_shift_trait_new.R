# Load required libraries
library(openxlsx)   # For reading Excel files
library(ggplot2)    # For plotting
library(reshape2)   # For data reshaping (not explicitly used here but loaded)

# Clear workspace
rm(list = ls())

# ---------------- Read input data ----------------
# Trait data (including hydraulic traits and shift rate)
traitt <- read.xlsx('D:\\ITRDB_5000\\Mountain_site\\fig.3data_shift_traits.xlsx', sheet = 1)

# Species shift rate standard deviation
shift <- read.xlsx('D:\\ITRDB_5000\\Mountain_site\\shift_spe_sd.xlsx', sheet = 1)

# Trait standard deviation data
trait_sd <- read.xlsx('D:\\ITRDB_5000\\Mountain_site\\trait_sd.xlsx', sheet = 1)

# Add standard deviation variables to main dataset
traitt$shift_sd <- shift$shift_sd   # SD of shift rate
traitt$p50_sd   <- trait_sd$P50     # SD of P50
traitt$tlp_sd   <- trait_sd$TLP     # SD of TLP
traitt$kl_sd    <- trait_sd$Kl      # SD of Kl
traitt <- merge(traitt, spec[, c("Code", "GROUP")],
                by.x = "species", by.y = "Code", all.x = TRUE)

# Replace missing GROUP values
traitt$GROUP[is.na(traitt$GROUP)] <- "Angiosperms"

# Convert to factor (recommended for plotting)
#traitt$GROUP <- factor(traitt$GROUP,
#                       levels = c("Gymnosperms", "Angiosperms"))

# ---------------- Plot 1: Shift rate vs P50 ----------------

ggplot(traitt, aes(p50, shift)) +
  geom_point(aes(color=GROUP,size=3)) + 
  # Add vertical error bars (shift uncertainty)
  geom_errorbar(aes(ymin = shift - shift_sd, ymax = shift + shift_sd), size = 0.1) +
  
  # Add horizontal error bars (trait uncertainty)
  geom_errorbarh(aes(xmin = p50 - p50_sd, xmax = p50 + p50_sd), size = 0.1) +
  
  # Color gradient (low → high shift rate)
  scale_color_manual(values = c("Gymnosperms" = "#1b9e77","Angiosperms" = "#d95f02" ))+
  
  # Linear regression fit
  geom_smooth(method = 'lm') +
  
  ylim(-10, 20) +
  xlab(expression(P[50]~(MPa)))+
  ylab(expression("Shift rate"~(m~year^{-1})))+
  theme_bw()

# Save figure
ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_shift_p50.tiff",
       width = 6.5, height = 5, dpi = 300)


# ---------------- Plot 2: Shift rate vs TLP ----------------

# Merge taxonomic group (Gymnosperm / Angiosperm) into trait data


ggplot(traitt, aes(tlp, shift)) +
  geom_point(aes(color=GROUP,size=3)) + 
  geom_errorbar(aes(ymin = shift - shift_sd, ymax = shift + shift_sd), size = 0.1) +
  geom_errorbarh(aes(xmin = tlp - tlp_sd, xmax = tlp + tlp_sd), size = 0.1) +
  geom_smooth(method = 'lm') +
  scale_color_manual(values = c("Gymnosperms" = "#1b9e77","Angiosperms" = "#d95f02" ))+
  ylim(c(-5, 10)) +
  xlab('TLP(MPa)') +
  ylab(expression("Shift rate"~(m~year^{-1})))+
  theme_bw()

ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_shift_tlp.tiff",
       width = 6.5, height = 5, dpi = 300)


# ---------------- Plot 3: Shift rate vs Kl ----------------
ggplot(traitt, aes(Kl, shift)) +
  geom_point(aes(color=GROUP,size=3)) + 
  geom_errorbar(aes(ymin = shift - shift_sd, ymax = shift + shift_sd), size = 0.1) +
  geom_errorbarh(aes(xmin = Kl - kl_sd, xmax = Kl + kl_sd), size = 0.1) +
  geom_smooth(method = 'lm') +
  scale_color_manual(values = c("Gymnosperms" = "#1b9e77","Angiosperms" = "#d95f02" ))+
  ylim(-5, 10) +
  # xlim(0,10)  # Optional x-axis limit (currently commented out)
  xlab(expression(K[l]~(kg~m^{-1}~s^{-1}~MPa^{-1})))+
  ylab(expression("Shift rate"~(m~year^{-1})))+
  theme_bw()

ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_shift_Kl-4-18.tiff",
       width = 6.5, height = 5, dpi = 300)


# ---------------- Plot 4: Trait importance (correlation) ----------------
# Read trait-correlation data (Sheet 2)
traitt <- read.xlsx('D:\\ITRDB_5000\\Mountain_site\\fig.3data_shift_traits.xlsx', sheet = 2)

# Order traits by correlation coefficient (ascending)
traitt$trait <- factor(traitt$trait, levels = traitt$trait[order(traitt$cr)])

# Bar plot showing correlation strength
ggplot(traitt, aes(trait, cr)) +
  geom_bar(aes(fill = cr), stat = 'identity') +  # Bar height = correlation value
  
  # Diverging color scale for correlation
  scale_color_manual(values = c("Gymnosperms" = "#1b9e77","Angiosperms" = "#d95f02" ))+
  
  # ylim(c(-0.5,0.5))  # Optional limit (currently commented)
  ylab('Correlation coefficient') +
  xlab('Trait') +
  
  # Flip axes for better readability
  coord_flip()

# Save figure
ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_shift_crr.tiff",
       width = 4, height = 5, dpi = 300)