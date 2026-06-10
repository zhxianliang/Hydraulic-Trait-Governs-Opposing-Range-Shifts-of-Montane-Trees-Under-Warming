Global Mountain Tree Growth Responses, Hydraulic Traits and Species Range Shifts
Overview
This repository contains MATLAB and R scripts used to analyze global
mountain tree-ring datasets, climate-growth relationships, hydraulic
traits, elevational adaptation, and species range shifts.
The study integrates:
Global tree-ring chronologies from mountain ecosystems
Climate-growth correlations
Elevational gradients
Hydraulic functional traits
Species shift rates
Taxonomic comparisons between gymnosperms and angiosperms
---
Repository Structure
``` text
├── Fig.2
│   └── fig.2 species_new.R
├── Fig.3
│   └── fig.3_2026_4_5.R
├── Fig.4
│   └── fig.4_shift_trait_new.R
├── Fig.5
│   └── fig.5b.pca.R
├── Supplementary Figures
│   ├── fig.S1_ele_species.R
│   ├── fig.S2_ele_cr_4_9.R
│   ├── fig.S3_ele_cr_4_9.R
│   ├── fig.S4_ele_species_4_10.R
│   ├── fig.S5_ele_species_tem_4_10.R
│   ├── fig.S6_ele-shift-species_new.R
│   ├── fig.S7_climate_rate.R
│   └── fig.S9_tree_distribution.m
```
---
Main Figures
Fig. 2. Species-specific Climate Sensitivity
Quantifies growth responses to PDSI, precipitation, temperature, and
diurnal temperature range (DTR), with comparisons between gymnosperms
and angiosperms.
Fig. 3. Hydraulic Traits and Elevational Climate Responses
Evaluates relationships between hydraulic traits (Ks, Kl, P50, TLP) and
elevational climate responses.
Fig. 4. Hydraulic Traits and Species Shift Rates
Assesses how hydraulic strategies influence species elevational
migration rates.
Fig. 5. Principal Component Analysis
Explores multivariate trait coordination and major ecological strategy
axes.
---
Supplementary Figures
Fig. S1
Species elevation distributions across mountain ecosystems.
Fig. S2
Species-specific relationships between elevation and climate-growth
sensitivity.
Fig. S3
Temporal variation in elevation--climate relationships.
Fig. S4
Elevation dependence of drought (PDSI) sensitivity.
Fig. S5
Elevation dependence of temperature sensitivity.
Fig. S6
Species elevation distributions and migration rates.
Fig. S7
Relationship between regional warming rate and species shift rate.
Fig. S9
Global distribution of mountain tree-ring sampling sites.
---
Required R Packages
``` r
ggplot2
tidyverse
reshape2
openxlsx
readxl
plantlist
FactoMineR
factoextra
ggrepel
patchwork
R.matlab
```
Installation:
``` r
install.packages(c(
  "ggplot2","tidyverse","reshape2","openxlsx",
  "readxl","plantlist","FactoMineR","factoextra",
  "ggrepel","patchwork","R.matlab"
))
```
---
Data Requirements
Required input data include:
Tree-ring chronologies
Climate-growth correlation datasets
Species trait databases
Hydraulic trait measurements
Species migration-rate datasets
Geographic coordinates and elevation information
Supported formats:
``` text
.xlsx
.csv
.mat
.tif
```
---
Scientific Significance
This workflow links:
Climate Change → Climate Sensitivity → Hydraulic Adaptation → Species
Migration → Mountain Biodiversity Responses
The analytical framework provides a comprehensive approach for
understanding how climate sensitivity and hydraulic strategies jointly
shape species redistribution in mountain ecosystems under ongoing
climate change.
