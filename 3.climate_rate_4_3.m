%% --------------------------------------------------------
% Trend calculation
%
% Climate trends were estimated using ordinary least-
% squares linear regression. The regression slope
% represents the annual rate of climate change during
% 1951–1990 at each species range-shift location.
% --------------------------------------------------------
% =========================================================
% Script: climate_rate_4_3.m
%
% Purpose:
% Estimate long-term climate trends at species range-shift
% locations using CRU climate datasets.
%
% Climate variables:
%   - PDSI
%   - Precipitation
%   - Temperature
%
% Linear trends were calculated for the period 1951–1990
% using least-squares regression.
% =========================================================

%% --------------------------------------------------------
% Load climate datasets
% ---------------------------------------------------------

% Monthly precipitation
load('D:\ITRDB_5000\premon.mat')

% Monthly temperature
load('D:\ITRDB_5000\tmpmon.mat')

% Monthly PDSI
load('D:\ITRDB_5000\pdsimon.mat')


%% --------------------------------------------------------
% Calculate summer climate variables (June–August)
% ---------------------------------------------------------

% Mean summer PDSI
pdsig = mean(pdsimon(:,:,:,6:8),4,"omitnan");

% Mean summer precipitation
preg = mean(premon(:,:,:,6:8),4,"omitnan");

% Mean summer temperature
tmpg = mean(tmpmon(:,:,:,6:8),4,"omitnan");


%% --------------------------------------------------------
% Load species range-shift locations and ancillary data
% ---------------------------------------------------------

% Longitude and latitude of range-shift locations
shiftlonlat = shiftlon(:,5:6);

% Climate grid coordinates
load("D:\ITRDB_5000\crulatlon.mat")

% Species range-shift database
load("D:\ITRDB_5000\Mountain_site\climate_rate.mat")

% Reload latitude-longitude information
load("D:\ITRDB_5000\crulatlon.mat")


%% --------------------------------------------------------
% Estimate climate trends for each range-shift location
% ---------------------------------------------------------

for jj = 1:417

    %-----------------------------------------------------
    % Geographic coordinates
    %-----------------------------------------------------

    ll1 = shift(jj,1);    % Longitude
    ll2 = shift(jj,2);    % Latitude

    %-----------------------------------------------------
    % Find nearest CRU grid cell
    %-----------------------------------------------------

    latcha = latt - ll2;
    loncha = lonn - ll1;

    latch1 = find(abs(latcha) == min(abs(latcha)));
    lonch1 = find(abs(loncha) == min(abs(loncha)));

    %-----------------------------------------------------
    % Extract climate series (1951–1990)
    %-----------------------------------------------------

    pds = mean(mean(pdsig(lonch1,latch1,51:90),1,"omitnan"),2,"omitnan");
    pre = mean(mean(preg(lonch1,latch1,51:90),1,"omitnan"),2,"omitnan");
    tem = mean(mean(tmpg(lonch1,latch1,51:90),1,"omitnan"),2,"omitnan");

    % Convert to column vectors
    pds1 = reshape(pds,40,1);
    pre1 = reshape(pre,40,1);
    tem1 = reshape(tem,40,1);

    %-----------------------------------------------------
    % Estimate linear trends
    %-----------------------------------------------------

    % First-order polynomial regression
    pds1b = polyfit(1:40, pds1, 1);
    pre1b = polyfit(1:40, pre1, 1);
    tem1b = polyfit(1:40, tem1, 1);

    %-----------------------------------------------------
    % Store regression coefficients
    %-----------------------------------------------------

    % Trend (slope)
    pds_b(jj,1) = pds1b(1);
    pre_b(jj,1) = pre1b(1);
    tem_b(jj,1) = tem1b(1);

    % Intercept
    pds_int(jj,1) = pds1b(2);
    pre_int(jj,1) = pre1b(2);
    tem_int(jj,1) = tem1b(2);

end