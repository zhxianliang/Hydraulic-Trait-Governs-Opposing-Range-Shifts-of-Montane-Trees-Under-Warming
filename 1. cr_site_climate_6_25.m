% --------------------------------------------------------
% Methodological note
%
% For each tree-ring site, climate variables were extracted
% from the nearest CRU grid cell based on geographic
% coordinates. Summer climate conditions were represented
% by June–August averages for temperature and PDSI, and
% cumulative June–August precipitation. Site-level values
% were calculated as long-term means across the available
% observation period.
% --------------------------------------------------------
% =========================================================
% Script: site_climate.m
%
% Purpose:
% Extract mean summer climate conditions (June–August)
% for each tree-ring site using gridded climate datasets.
%
% Climate variables:
%   - PDSI (Palmer Drought Severity Index)
%   - Precipitation
%   - Temperature
%
% For each site, the nearest grid cell is identified and
% long-term mean climate conditions are extracted.
%
% =========================================================


% =========================================================
% Script: read_climate_data.m
%
% Purpose:
% Read monthly climate datasets from NetCDF files,
% including PDSI, minimum temperature, and precipitation,
% and save them as MATLAB variables for subsequent analyses.
% =========================================================

%% --------------------------------------------------------
% Read monthly PDSI
% ---------------------------------------------------------

% Open NetCDF file
nc1 = netcdf.open( ...
    'scPDSI.cru_ts4.05early1.1901.2020.cal_1901_20.bams.2021.GLOBAL.1901.2020.nc', ...
    'NC_NOWRITE');

% Read climate variable
pdsimon = netcdf.getVar(nc1,3);

% Close NetCDF file
netcdf.close(nc1);


%% --------------------------------------------------------
% Read monthly minimum temperature
% ---------------------------------------------------------

% Open NetCDF file
nc2 = netcdf.open( ...
    'cru_ts4.05.1901.2020.tmn.dat.nc', ...
    'NC_NOWRITE');

% Read climate variable
tmpmon = netcdf.getVar(nc2,3);

% Close NetCDF file
netcdf.close(nc2);


%% --------------------------------------------------------
% Read monthly precipitation
% ---------------------------------------------------------

% Open NetCDF file
nc3 = netcdf.open( ...
    'cru_ts4.05.1901.2020.pre.dat.nc', ...
    'NC_NOWRITE');

% Read climate variable
premon = netcdf.getVar(nc3,3);

% Close NetCDF file
netcdf.close(nc3);


%% --------------------------------------------------------
% Read monthly diurnal temperature range (DTR)
% ---------------------------------------------------------

% Open NetCDF file
nc4 = netcdf.open( ...
    'cru_ts4.05.1901.2020.dtr.dat.nc', ...
    'NC_NOWRITE');

% Read climate variable
dtr_m = netcdf.getVar(nc4,3);

% Close NetCDF file
netcdf.close(nc4);


%% --------------------------------------------------------
% Save extracted climate datasets
% ---------------------------------------------------------

save('climate_data.mat', ...
    'pdsimon', ...
    'tmpmon', ...
    'premon', ...
    'dtr_m');

%---------------------------------------------------------
% Load climate datasets
%---------------------------------------------------------


load('D:\ITRDB-5000\climate_data.mat')

% Tree-ring chronology data
load('crn.mat')

% Site latitude and longitude information
load('D:\ITRDB-5000\crulatlon.mat')

% Additional site metadata
load('infor.mat')

% Site elevation information
load elee.mat

%---------------------------------------------------------
% Calculate summer climate variables (June–August)
%---------------------------------------------------------

% Mean summer PDSI
pdsig = nanmean(pdsimon(:,:,:,6:8),4);

% Total summer precipitation
preg = nansum(premon(:,:,:,6:8),4);

% Mean summer temperature
tmpg = nanmean(tmpmon(:,:,:,6:8),4);

%---------------------------------------------------------
% Extract climate values for each site
%---------------------------------------------------------

for i = 1:3783

    %-----------------------------------------------------
    % Site coordinates
    %-----------------------------------------------------

    % Longitude of tree-ring site
    ll1 = latlon(i,5);

    % Latitude of tree-ring site
    ll2 = latlon(i,6);

    %-----------------------------------------------------
    % Calculate distance to climate grid
    %-----------------------------------------------------

    % Latitude difference
    latcha = latt - ll2;

    % Longitude difference
    loncha = lonn - ll1;

    % Find nearest latitude grid cell
    latch1 = find(abs(latcha) == min(abs(latcha)));

    % Find nearest longitude grid cell
    lonch1 = find(abs(loncha) == min(abs(loncha)));

    %-----------------------------------------------------
    % Extract climate variables from nearest grid cell
    %-----------------------------------------------------

    % Mean PDSI across all available years
    pdss(i,1) = nanmean( ...
                  nanmean( ...
                  nanmean( ...
                  pdsig(lonch1,latch1,:),1),2),3);

    % Mean summer precipitation
    pree(i,1) = nanmean( ...
                  nanmean( ...
                  nanmean( ...
                  preg(lonch1,latch1,:),1),2),3);

    % Mean summer temperature
    temm(i,1) = nanmean( ...
                  nanmean( ...
                  nanmean( ...
                  tmpg(lonch1,latch1,:),1),2),3);

end