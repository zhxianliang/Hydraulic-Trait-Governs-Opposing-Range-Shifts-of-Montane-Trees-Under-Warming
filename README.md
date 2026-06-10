Hydraulic Trait Governs Opposing Range Shifts of Montane Trees Under Warming
Repository Overview

This repository contains all scripts used to generate the analyses and figures presented in the manuscript:

Hydraulic Trait Governs Opposing Range Shifts of Montane Trees Under Warming

The study investigates how hydraulic traits regulate species-specific elevational range shifts across global mountain forests under recent climate warming.

Using tree-ring records, climatic data, hydraulic trait databases, and species distribution information, we quantify:

species-specific climate sensitivity;
elevational variation in climate-growth relationships;
hydraulic controls on climate adaptation;
hydraulic determinants of range-shift rates.
Scientific Background

Mountain ecosystems are experiencing rapid warming and widespread redistribution of species. Although upslope migration is often expected, observed responses vary substantially among species, with some species expanding upslope while others show limited movement or even downslope shifts. Functional traits are increasingly recognized as important predictors of these heterogeneous responses.

This study evaluates whether hydraulic traits provide a mechanistic explanation for these contrasting range-shift responses.

Data Sources
Tree-ring database
International Tree-Ring Data Bank (ITRDB)
Mountain tree-ring chronologies
Climate data
Temperature
Precipitation
Palmer Drought Severity Index (PDSI)
Diurnal Temperature Range (DTR)
Functional traits
Hydraulic conductivity (Ks)
Leaf-specific conductivity (Kl)
Turgor loss point (TLP)
Xylem vulnerability (P50)
Species distributions
Geographic coordinates
Elevation records
Range-shift rates
Repository Structure
├── Main Figures
│   ├── fig.2 species_new.R
│   ├── fig.3_2026_4_5.R
│   ├── fig.4_shift_trait_new.R
│   └── fig.5b.pca.R
│
├── Supplementary Figures
│   ├── fig.S1_ele_species.R
│   ├── fig.S2_ele_cr_4_9.R
│   ├── fig.S3_ele_cr_4_9.R
│   ├── fig.S4_ele_species_4_10.R
│   ├── fig.S5_ele_species_tem_4_10.R
│   ├── fig.S6 ele-shife-species_new.R
│   ├── fig.S7 climate rate.R
│   └── fig.S9 tree_distribution.m
│
├── Data
│   ├── Climate data
│   ├── Trait data
│   ├── Species metadata
│   └── Geographic information
│
└── README.md
Figure Reproducibility
Figure	Description	Script
Fig. 2	Species-specific climate sensitivity	fig.2 species_new.R
Fig. 3	Hydraulic traits and elevational climate responses	fig.3_2026_4_5.R
Fig. 4	Hydraulic controls on range shifts	fig.4_shift_trait_new.R
Fig. 5	Trait coordination and PCA	fig.5b.pca.R
Fig. S1	Elevation distributions	fig.S1_ele_species.R
Fig. S2	Elevation–climate relationships	fig.S2_ele_cr_4_9.R
Fig. S3	Temporal climate responses	fig.S3_ele_cr_4_9.R
Fig. S4	Elevation effects on drought sensitivity	fig.S4_ele_species_4_10.R
Fig. S5	Elevation effects on temperature sensitivity	fig.S5_ele_species_tem_4_10.R
Fig. S6	Shift-rate distributions	fig.S6 ele-shife-species_new.R
Fig. S7	Warming rate versus shift rate	fig.S7 climate rate.R
Fig. S9	Global site distribution	fig.S9 tree_distribution.m
Analytical Workflow
Tree-ring records
        │
        ▼
Climate-growth correlations
        │
        ▼
Elevational analyses
        │
        ▼
Hydraulic trait integration
        │
        ▼
Species range-shift estimation
        │
        ▼
Trait-based interpretation of migration responses
Software Requirements
R

Version ≥ 4.2

Required packages:

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
MATLAB

Version ≥ R2022a

Required toolboxes:

Mapping Toolbox
Statistics and Machine Learning Toolbox
Reproducibility Statement

All figures reported in the manuscript can be reproduced directly using the scripts provided in this repository after updating local file paths to the corresponding datasets.

Code Availability

All code necessary to reproduce the analyses and figures is publicly available in this repository.

Citation

If you use these scripts or derived products, please cite:

Zhang X., et al. Hydraulic Trait Governs Opposing Range Shifts of Montane Trees Under Warming. Nature Climate Change (Accepted).

Contact

Xianliang Zhang

Faculty of Forestry, University of British Columbia

College of Forestry, Hebei Agricultural University

Email: zhxianliang85@gmail.com
