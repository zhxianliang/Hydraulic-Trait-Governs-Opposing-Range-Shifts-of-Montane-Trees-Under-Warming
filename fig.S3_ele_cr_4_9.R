
# Fig. S3

library(ggplot2)
library(reshape2)
library(plantlist)
library(openxlsx)
library(readxl)

# Clear workspace
rm(list = ls())

# Read data for temporal changes in elevation–climate correlations
yycor <- read.xlsx("D:\\ITRDB_5000\\Mountain_site\\data\\fig.S3_data_ele_cr.xlsx", sheet = 1)
yycr <- melt(yycor, c("smaplesize", "species"))

# Assign climate groups
yycr$group <- NA
yycr$group[1:495] <- "PDSI"
yycr$group[496:990] <- "PRE"
yycr$group[991:1485] <- "TEM"
yycr$group[1486:1980] <- "DTR"

# Clean variable names
yycr$variable <- as.character(yycr$variable)
yycr$variable <- gsub("pd_", "", yycr$variable)
yycr$variable <- gsub("pre_", "", yycr$variable)
yycr$variable <- gsub("tem_", "", yycr$variable)
yycr$variable <- gsub("dtr_", "", yycr$variable)

# Set period order
yycr$variable <- factor(yycr$variable, levels = paste0("p", 1:11))

# Read species codes
specode <- read_excel("D:/ITRDB_5000/Mountain_site/Table.S.xlsx",
                      sheet = "Sheet3")[, 1:2]

# Standardize species names and merge species codes
spec <- TPL(specode$species)
spec <- merge(spec, specode, by.x = "YOUR_SEARCH", by.y = "species")

# Remove spaces to match species labels in plotting data
yycr$species <- gsub(" ", "", yycr$species)

# Order species by taxonomic group
spec <- spec[order(spec$GROUP), ]
yycr$species <- factor(yycr$species, levels = spec$code)

# Mark highlighted points using the original threshold
# Note: this is a correlation-strength threshold rather than a formal significance test
yycr$sig <- abs(yycr$value) > 0.4

# Create plot
p <- ggplot(yycr, aes(variable, species)) +
  
  # Filled points showing correlation direction and magnitude
  geom_point(aes(color = value, size = abs(value)),
             shape = 16, alpha = 0.85) +
  
  # Hollow circle overlay
  geom_point(aes(size = abs(value)),
             shape = 1, stroke = 0.8, color = "black") +
  
  # Add asterisk to highlighted points
  geom_text(data = yycr[yycr$sig, ],
            aes(label = "*"),
            size = 3.4,
            color = "black",
            fontface = "bold",
            vjust = 0.5,
            hjust = 0.5) +
  
  # Publication-style diverging palette
  scale_color_gradient2(
    low = "#3E5C99",
    mid = "#F7F7F7",
    high = "#B45A52",
    midpoint = 0,
    limits = c(-1, 1),
    name = "Correlation"
  ) +
  
  # Increase point-size contrast
  scale_size_continuous(
    range = c(2.5, 5),
    breaks = c(0.2, 0.4, 0.6, 0.8),
    name = "|Correlation|"
  ) +
  
  # Facet by climate variable
  facet_wrap(. ~ group, nrow = 1) +
  
  # Axis labels
  xlab("Periods") +
  ylab("Species") +
  
  # Theme
  theme_bw() +
  theme(
    strip.background = element_rect(fill = "white", color = "black"),
    strip.text = element_text(size = 11, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 9),
    axis.text.y = element_text(size = 7),
    axis.title = element_text(size = 11),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.2, color = "grey90")
  )

# Display plot
p

# Save figure
ggsave("D:\\ITRDB_5000\\Mountain_site\\fig_2026_4_5\\fig_ele_cr_period.tiff",
       plot = p, width = 10, height = 10, dpi = 300)
