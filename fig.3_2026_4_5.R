# Load required libraries
library(ggplot2)   # For plotting
library(reshape2)  # For data reshaping (melt function)
library(openxlsx)  # For reading Excel files

# Clear workspace
rm(list=ls())

# Read correlation and trait data (Sheet 3)
yycor <- read.xlsx("D:\\ITRDB_5000\\Mountain_site\\data\\fig3_data_cr_ele_trait.xlsx", sheet=3)

# Extract Ks-related columns (Ks + climate variables)
yycr <- yycor[, c(4, 24:27)]
yycr1 <- melt(yycr, c('Ks'))  # Convert to long format

# Extract standard deviation (Ks_sd and correlation SD)
yycrr <- yycor[, c(15, 28:31)]
yycrr1 <- melt(yycrr, c('Ks_sd'))

# Add SD information to main dataset
yycr1$Ks_sd <- yycrr1$Ks_sd
yycr1$cr_sd <- yycrr1$value

# Read mean and SD trait datasets
elecr_trait_m  <- read.xlsx('D:\\ITRDB_5000\\Mountain_site\\data\\fig3_data_elecr_trait_m.xlsx')
elecr_trait_sd <- read.xlsx('D:\\ITRDB_5000\\Mountain_site\\data\\fig3_data_elecr_trait_sd.xlsx')

## Fig 2 ---------------------------------------------------------------

# Read main data (Sheet 1)
yycor <- read.xlsx("D:\\ITRDB_5000\\Mountain_site\\data\\fig3_data_cr_ele_trait.xlsx", sheet=1)

# ---------------- Ks vs climate response ----------------
yycr <- yycor[, c(2, 6:8)]
yycr1 <- melt(yycr, c('Ks'))

ggplot(yycr1, aes(Ks, value, group = variable)) +
  geom_point(aes(color = variable, size = abs(value))) +  # Scatter points with color and size mapping
  
  # Optional error bars (currently commented out)
  # geom_errorbar(aes(ymin = Ks-Ks_sd, ymax = Ks+Ks_sd), size=0.1) +
  # geom_errorbarh(aes(xmin=value-cr_sd,xmax = value+cr_sd), size=0.1) +
  
  # Highlight points with strong correlation (> 0.3)
  geom_point(data = yycr1[yycr1$value > 0.3, ], aes(Ks, value), pch=8, size=1) +
  
  # Add linear regression lines
  geom_smooth(method = 'lm', aes(linetype = variable, color = variable)) +
  
  # Customize line types
  scale_linetype_manual(values = c("dashed", "dashed", 'solid')) +
  
  # Color gradient (not used in current mapping)
  scale_fill_gradientn(colors=c('green','blue','red')) +
  
  ylim(-1, 1) +
  xlab(expression(K[s]~(kg~m^{-1}~s^{-1}~MPa^{-1}))) +
  ylab('Elevational climate response') +
  theme_bw()

# Save figure
ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_ele_ks-4-8.tiff", width = 6, height = 5, dpi = 300)


# ---------------- Kl vs climate response ----------------
yycr2 <- yycor[, c(3, 6:8)]
yycr22 <- melt(yycr2, c('Kl'))

ggplot(yycr22, aes(Kl, value, group = variable)) +
  geom_point(aes(color = variable, size = abs(value), shape = variable)) +
  geom_point(data = yycr22[yycr22$value > 0.3, ], aes(Kl, value), pch=8, size=1) +
  geom_smooth(method = 'lm', aes(linetype = variable, color = variable)) +
  scale_linetype_manual(values = c("dashed", "dashed", 'solid')) +
  ylim(-1, 1) +
  xlab(expression(K[l]~(kg~m^{-1}~s^{-1}~MPa^{-1}))) +
  ylab('Elevational climate response') +
  theme_bw()

ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_ele_kl-4-8.tiff", width = 6, height = 5, dpi = 300)


# ---------------- P50 vs climate response ----------------
yycr4 <- yycor[, c(5:8)]
yycr42 <- melt(yycr4, c('P50'))

ggplot(yycr42, aes(P50, value, group = variable)) +
  geom_point(aes(color = variable, size = abs(value), shape = variable)) +
  geom_point(data = yycr42[yycr42$value > 0.3, ], aes(P50, value), pch=8, size=1) +
  geom_smooth(method = 'lm', aes(linetype = variable, color = variable)) +
  scale_linetype_manual(values = c("dashed", "dashed", 'solid')) +
  ylim(-1, 1) +
  xlab(expression(P[50]~(MPa))) +
  ylab('Elevational climate response') +
  theme_bw()

ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_ele_P50-4-8.tiff", width = 6, height = 5, dpi = 300)


# ---------------- TLP vs climate response ----------------
yycr5 <- yycor[, c(4, 6:8)]
yycr52 <- melt(yycr5, c('TLP'))

ggplot(yycr52, aes(TLP, value, group = variable)) +
  geom_point(aes(color = variable, size = abs(value), shape = variable)) +
  geom_smooth(method = 'lm', aes(linetype = variable, color = variable)) +
  scale_linetype_manual(values = c("dashed", "solid", 'dashed')) +
  ylim(-1, 1) +
  xlab(expression(TLP~(MPa))) +
  ylab('Elevational climate response') +
  theme_bw()

ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_ele_TLP-4-8.tiff", width = 6, height = 5, dpi = 300)


# ---------------- Trait vs climate correlation heat-like plot ----------------
pp <- read.xlsx("D:\\ITRDB_5000\\Mountain_site\\fig2data_cr_ele_trait.xlsx", sheet=2)
ppp <- melt(pp)

ggplot(ppp, aes(variable, trait)) +
  geom_point(aes(color = value, size = abs(value))) +
  geom_point(shape = 1, aes(size = abs(value))) +
  scale_color_gradient2(low = "#3B4CC0", mid = "white", high = "#B40426")+
  geom_point(data = ppp[ppp$value > 0.3, ], aes(variable, trait), pch=8, size=2) +
  
  scale_y_discrete(labels = c(
    "WD"   = expression(WD),
    "Vdia" = expression(V[dia]),
    "TLP"  = expression(TLP),
    "Ppd"  = expression(P[pd]),
    "Pmd"  = expression(P[md]),
    "P50"  = expression(P[50]),
    "Ks"   = expression(K[s]),
    "Kl"   = expression(K[l]),
    "Hmax" = expression(H[max]),
    "Hact" = expression(H[act]),
    "AIAs" = expression(AI[As])
  )) +
  
  xlab('Climate variable') +
  ylab('Trait') +
  theme_bw()



ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_ele_traitcr.tiff", width = 3, height = 5, dpi = 300)
