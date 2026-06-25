%% --------------------------------------------------------
% Methodological note
%
% Climate-growth relationships were quantified using
% Pearson correlation coefficients between tree-ring
% chronologies and summer (June–August) climate variables.
% Climate data were extracted from the nearest CRU grid cell,
% and correlations were calculated over the common period
% 1901–1970.
% --------------------------------------------------------
% =========================================================
% Script: site_corr.m
%
% Purpose:
% Calculate site-level climate-growth relationships for
% tree-ring chronologies using summer (June–August)
% climate variables.
%
% Climate variables:
%   - PDSI
%   - Precipitation
%   - Temperature
%   - Diurnal Temperature Range (DTR)
%
% Correlations are calculated for the first 70 years of
% each chronology (1901–1970) and stored for subsequent
% analyses.
% =========================================================

%% --------------------------------------------------------
% Load climate datasets
% --------------------------------------------------------

% Monthly precipitation
load('D:\ITRDB_5000\premon.mat')

% Monthly temperature
load('D:\ITRDB_5000\tmpmon.mat')

% Monthly PDSI
load('D:\ITRDB_5000\pdsimon.mat')

% Monthly diurnal temperature range (DTR)
load('D:\ITRDB_5000\dtr_m.mat','dtr_m')

%% --------------------------------------------------------
% Load tree-ring and site information
% --------------------------------------------------------

% Tree-ring chronologies
load('crn.mat')

% Site coordinates
load('D:\ITRDB_5000\crulatlon.mat')

% Site metadata
load('infor.mat')

% Site elevation
load elee.mat

%% --------------------------------------------------------
% Restrict chronology length
% --------------------------------------------------------

% Retain the first 120 years of each chronology
crnn(121:end,:) = [];

%% --------------------------------------------------------
% Calculate summer climate variables (June–August)
% --------------------------------------------------------

% Mean summer PDSI
pdsig = nanmean(pdsimon(:,:,:,6:8),4);

% Mean summer precipitation
preg = nanmean(premon(:,:,:,6:8),4);

% Mean summer temperature
tmpg = nanmean(tmpmon(:,:,:,6:8),4);

% Mean summer DTR
dtrg = nanmean(dtr_m(:,:,:,6:8),4);

%% --------------------------------------------------------
% Species information
% --------------------------------------------------------

spec = infor(1:end-1,4);
specu = unique(spec);

% Optional elevation information
% ele = infor(:,7);
% ele = cell2mat(ele);

%% --------------------------------------------------------
% Calculate site-level climate-growth correlations
% --------------------------------------------------------

for i = 1:3783

    % Tree-ring chronology
    nbb = crnn(:,i);

    %-----------------------------------------------------
    % Site coordinates
    %-----------------------------------------------------

    ll1 = latlon(i,5);    % Longitude
    ll2 = latlon(i,6);    % Latitude

    %-----------------------------------------------------
    % Identify nearest climate grid cell
    %-----------------------------------------------------

    latcha = latt - ll2;
    loncha = lonn - ll1;

    latch1 = find(abs(latcha) == min(abs(latcha)));
    lonch1 = find(abs(loncha) == min(abs(loncha)));

    %-----------------------------------------------------
    % Extract climate time series
    %-----------------------------------------------------

    pds = nanmean(nanmean(pdsig(lonch1,latch1,:),1),2);
    pre = nanmean(nanmean(preg(lonch1,latch1,:),1),2);
    tem = nanmean(nanmean(tmpg(lonch1,latch1,:),1),2);
    dtr = nanmean(nanmean(dtrg(lonch1,latch1,:),1),2);

    %-----------------------------------------------------
    % Calculate climate-growth correlations
    %-----------------------------------------------------

    % First 70 years (1901–1970)
    cc1 = corrcoef(pds(1:70), nbb(1:70), 'rows','complete');
    cc2 = corrcoef(pre(1:70), nbb(1:70), 'rows','complete');
    cc3 = corrcoef(tem(1:70), nbb(1:70), 'rows','complete');
    cc4 = corrcoef(dtr(1:70), nbb(1:70), 'rows','complete');

    %-----------------------------------------------------
    % Store correlation coefficients
    %-----------------------------------------------------

    cccpd(i,1)  = cc1(1,2);
    cccpre(i,1) = cc2(1,2);
    ccctem(i,1) = cc3(1,2);
    cccdtr(i,1) = cc4(1,2);

end

%% --------------------------------------------------------
% Save site-level climate sensitivity
% --------------------------------------------------------

save('site_cor.mat', ...
    'cccpd', ...
    'cccpre', ...
    'ccctem', ...
    'cccdtr');