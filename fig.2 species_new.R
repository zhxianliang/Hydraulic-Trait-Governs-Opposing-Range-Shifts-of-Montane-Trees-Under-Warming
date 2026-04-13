# Load required libraries
library(R.matlab)      # For reading MATLAB .mat files
library(tidyverse)     # Data manipulation and visualization
library(ggplot2)       # Plotting
library(reshape2)      # Data reshaping (melt function)
library(openxlsx)      # Excel file handling
#library(ggpubr)

# Clear workspace
rm(list = ls()) 

# Read MATLAB data containing climate correlations
ele_cr <- readMat("D:\\ITRDB_5000\\Mountain_site\\fig2_data_ele_clim_cr_ran_new.mat")

# Extract species names (stored as MATLAB cell array)
ssp <- ele_cr$ssp
spec <- unlist(ssp)

# Remove whitespace in species codes
spec <- gsub(" ","", spec)

# -------- Extract PDSI correlation --------
pd_cr1 <- ele_cr$pd.crr[,11,]         # Select slice 11 (e.g., elevation band)
rownames(pd_cr1) <- spec             # Assign species codes as row names
pd_cr11 <- melt(pd_cr1)              # Convert to long format

# -------- Extract precipitation correlation --------
pre_cr1 <- ele_cr$pre.crr[,11,]
rownames(pre_cr1) <- spec
pre_cr11 <- melt(pre_cr1)

# -------- Extract temperature correlation --------
tem_cr1 <- ele_cr$tem.crr[,11,]
rownames(tem_cr1) <- spec
tem_cr11 <- melt(tem_cr1)

# -------- Extract diurnal temperature range (DTR) --------
dtr_cr1 <- ele_cr$dtr.crr[,11,]
rownames(dtr_cr1) <- spec
dtr_cr11 <- melt(dtr_cr1)

# Assign climate variable labels
pd_cr11$type  <- "PDSI"
pre_cr11$type <- "Precipitation"
tem_cr11$type <- "Temperature"
dtr_cr11$type <- "DTR"

# Combine all variables into one dataset
corvalue <- rbind(pd_cr11, pre_cr11, tem_cr11, dtr_cr11)

# Ensure species code is character
corvalue$Var1 <- as.character(corvalue$Var1)

# Fix inconsistent species code
corvalue[corvalue$Var1 == "ACSA", ]$Var1 <- "ACSH"

# Extract unique species list
spec <- levels(as.factor(corvalue$Var1))

# Load additional libraries for taxonomy and metadata
library(readxl)
library(plantlist)

# Read species metadata (e.g., elevation, species name)
code <- read_excel("D:\\ITRDB_5000\\fig2_data_yangben.xlsx")
#View(code)

# Aggregate mean elevation by species and species code
bbb <- aggregate(code$alt, by = list(code$species, code$specode), mean)

# Keep only species that exist in correlation dataset
bbb <- bbb[bbb$Group.2 %in% spec, ]

# Query taxonomic information using The Plant List (TPL)
ccc <- TPL(bbb$Group.1)

# Merge taxonomy with metadata
ddd <- merge(ccc, bbb, by.x = "YOUR_SEARCH", by.y = "Group.1")

# Order species by taxonomic group
ddd <- ddd[order(ddd$GROUP), ]

# Set species factor levels according to taxonomic order
corvalue$Var1 <- factor(as.character(corvalue$Var1), levels = ddd$Group.2)

# Remove rows with missing values
corvalue <- na.omit(corvalue)

# Copy dataset for plotting
colres <- corvalue

# Create a combined index (species + climate variable)
colres$index <- paste0(colres$Var1, colres$type)

# Calculate mean correlation for each species-variable combination
colressum <- aggregate(colres$value, by = list(colres$index), mean, na.rm = TRUE)

# Merge mean values back to original dataset
colres <- merge(colres, colressum, by.x = "index", by.y = "Group.1", all.x = TRUE)
# Add taxonomic group information to plotting data
colres <- merge(colres, ddd[, c("Group.2", "GROUP")],
                by.x = "Var1", by.y = "Group.2", all.x = TRUE)

# -------- Plotting --------
ggplot(colres) +
  aes(x = Var1, y = value) +
  geom_boxplot(aes(fill = GROUP), notch = TRUE) +   # Fill by taxonomic group
  scale_color_manual(values = c("Gymnosperms" = "#1b9e77","Angiosperms" = "#d95f02" ))+           # Discrete palette
  theme_bw() +
  facet_grid(vars(type)) +
  xlab(NULL) +
  theme(axis.text.x = element_text(angle = 90)) +
  ylab("Correlation coefficient") +
  xlab('Species') +
  geom_hline(yintercept = 0, linewidth = 0.5, linetype = 5)



# Save figure to file
ggsave(
  "D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig2_2026_4_5.tiff",
  width = 12,
  height = 6,
  dpi = 300
)
