This directory contains the scripts used to process tree-ring chronologies, climate datasets, and species range-shift observations for the analyses presented in the manuscript:

Hydraulic Traits Govern Opposing Range Shifts of Montane Trees Under Warming

The workflow integrates tree-ring chronologies, CRU climate data, BioShifts observations, and hydraulic trait datasets to quantify temporal climate sensitivity, elevational dependence of growth responses, and their relationships with species elevational range shifts.

Workflow

The data processing pipeline follows the steps below:

CRU NetCDF climate data
        │
        ▼
read_climate_data.m
        │
        ▼
Monthly climate variables
(PDSI, Temperature, Precipitation, DTR)
        │
        ├──────────────┐
        ▼              ▼
site_climate.m     site_corr.m
        │              │
        ▼              ▼
Site climate      Site climate sensitivity
        │
        ▼
temporal_cr_6_25.m
        │
        ▼
Moving-window climate-growth correlations
        │
        ▼
species_ele_cor.m
        │
        ▼
Species elevational dependence
        │
        ▼
bioshift_cr.R
        │
        ▼
Merged BioShifts + climate sensitivity dataset
Scripts
Climate data preparation
read_climate_data.m

Reads monthly climate variables from CRU TS4.05 NetCDF datasets.

Input

CRU TS4.05 NetCDF files
PDSI
Minimum temperature
Precipitation
Diurnal Temperature Range (DTR)

Output

climate_data.mat
site_climate.m

Extracts long-term summer climate conditions for each tree-ring site from the nearest CRU grid cell.

Summer climate is represented by:

June–August mean temperature
June–August mean PDSI
June–August precipitation

Output

Site-level climate variables.

Climate-growth relationships
site_corr.m

Calculates site-level Pearson correlations between tree-ring chronologies and summer climate variables over the common period (1901–1970).

Climate variables include

PDSI
Temperature
Precipitation
DTR

Output

site_cor.mat
temporal_cr_6_25.m

Calculates moving-window climate-growth correlations.

Parameters

Window length: 40 years
Step size: 5 years
Total windows: 11

Outputs temporal changes in climate sensitivity for every tree-ring site.

Elevational dependence
species_ele_cor.m

Quantifies elevational dependence of climate sensitivity for each species.

Procedure

species with >20 sites retained
random sampling of 20 sites
100 bootstrap iterations
Pearson correlation between elevation and climate sensitivity

Outputs

mean bootstrap correlation
bootstrap standard deviation
Species range shifts
bioshift_cr.R

Matches BioShifts records with the nearest tree-ring climate-sensitivity record of the same species.

Extracted variables include

PDSI sensitivity
Temperature sensitivity
Precipitation sensitivity
Elevation

Outputs

bioshift_cr.csv
chuli_ele_cr_species.R

Processes species-level elevation information and merges taxonomic classifications with climate sensitivity data for downstream analyses.

climate_rate_4_3.m

Calculates long-term linear trends (1951–1990) of climate variables at species range-shift locations.

Climate trends are estimated using ordinary least-squares regression.

Outputs include annual trends for

PDSI
Temperature
Precipitation
Data Requirements

The scripts require the following datasets:

Tree-ring chronologies
Site coordinates
Site elevation
Species metadata
CRU TS4.05 climate datasets
BioShifts database
Hydraulic trait database

Large input datasets are not included in this repository because of licensing and file-size limitations.

Software
MATLAB

Tested with

MATLAB R2023b or later

Required Toolboxes

Statistics and Machine Learning Toolbox
R

Tested with

R ≥ 4.3

Required packages

openxlsx
readxl
ggplot2
reshape2
plantlist
Notes
Climate variables were extracted from the nearest CRU grid cell based on site coordinates.
Summer climate represents the June–August growing season.
Climate-growth relationships were quantified using Pearson correlation coefficients.
Temporal changes were evaluated using 40-year moving windows with a 5-year step.
Species-level analyses used bootstrap resampling to reduce sampling bias associated with unequal numbers of tree-ring sites.
Citation

If you use this code, please cite the associated manuscript:

Zhang X., et al. Hydraulic Traits Govern Opposing Range Shifts of Montane Trees Under Warming.
