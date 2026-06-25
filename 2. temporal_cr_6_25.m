% Temporal non-stationarity in climate-growth relationships
% was quantified using 40-year moving-window correlations
% with a 5-year step size, allowing assessment of gradual
% shifts in tree sensitivity to drought and climate over time.
% =========================================================
% Script: temporal_cr_6_25.m
%
% Purpose:
% Quantify temporal changes in climate-growth relationships
% using moving-window correlation analysis.
%
% Climate variables:
%   - PDSI
%   - Precipitation
%   - Temperature
%   - Diurnal Temperature Range (DTR)
%
% For each tree-ring site, correlations are calculated
% within a 40-year moving window, shifted every 5 years.
%
% =========================================================

%---------------------------------------------------------
% Load climate datasets
%---------------------------------------------------------

load('D:\ITRDB_5000\premon.mat')      % Monthly precipitation
load('D:\ITRDB_5000\tmpmon.mat')      % Monthly temperature
load('D:\ITRDB_5000\pdsimon.mat')     % Monthly PDSI
load('D:\ITRDB_5000\dtr_m.mat','dtr_m') % Monthly DTR

%---------------------------------------------------------
% Load tree-ring and site information
%---------------------------------------------------------

load('crn.mat')                       % Tree-ring chronologies
load('D:\ITRDB_5000\crulatlon.mat')   % Site coordinates
load('infor.mat')                     % Site metadata
load elee.mat                         % Elevation information

%---------------------------------------------------------
% Restrict chronology period
%---------------------------------------------------------

% Retain the first 120 years
crnn(121:end,:) = [];

%---------------------------------------------------------
% Calculate summer climate variables (June¨CAugust)
%---------------------------------------------------------

% Mean summer PDSI
pdsig = nanmean(pdsimon(:,:,:,6:8),4);

% Mean summer precipitation
preg  = nanmean(premon(:,:,:,6:8),4);

% Mean summer temperature
tmpg  = nanmean(tmpmon(:,:,:,6:8),4);

% Mean summer DTR
dtrg  = nanmean(dtr_m(:,:,:,6:8),4);

%---------------------------------------------------------
% Species information
%---------------------------------------------------------

spec  = infor(1:end-1,4);
specu = unique(spec);

% Optional elevation information
% ele = infor(:,7);
% ele = cell2mat(ele);

%% =======================================================
% Moving-window climate-growth correlations
% ========================================================

for nnn = 1:11

    %-----------------------------------------------------
    % Define moving window
    %-----------------------------------------------------

    % Ending year index
    nyear = 40 + 5*(nnn-1);

    % Starting year index
    ni = 1 + 5*(nnn-1);

    for i = 1:3783

        % Tree-ring chronology
        nbb = crnn(:,i);

        %-------------------------------------------------
        % Site coordinates
        %-------------------------------------------------

        ll1 = latlon(i,5);   % longitude
        ll2 = latlon(i,6);   % latitude

        % Find nearest climate grid cell
        latcha = latt - ll2;
        loncha = lonn - ll1;

        latch1 = find(abs(latcha)==min(abs(latcha)));
        lonch1 = find(abs(loncha)==min(abs(loncha)));

        %-------------------------------------------------
        % Extract site climate series
        %-------------------------------------------------

        pds = nanmean(nanmean(pdsig(lonch1,latch1,:),1),2);
        pre = nanmean(nanmean(preg(lonch1,latch1,:),1),2);
        tem = nanmean(nanmean(tmpg(lonch1,latch1,:),1),2);
        dtr = nanmean(nanmean(dtrg(lonch1,latch1,:),1),2);

        %-------------------------------------------------
        % Select moving-window period
        %-------------------------------------------------

        nb1   = nbb(ni:nyear,:);

        pdsi1 = pds(:,:,ni:nyear);
        pre1  = pre(:,:,ni:nyear);
        tem1  = tem(:,:,ni:nyear);
        dtr1  = dtr(:,:,ni:nyear);

        %-------------------------------------------------
        % Climate-growth correlations
        %-------------------------------------------------

        cc1 = corrcoef(pdsi1, nb1,'rows','complete');
        cc2 = corrcoef(pre1,  nb1,'rows','complete');
        cc3 = corrcoef(tem1,  nb1,'rows','complete');
        cc4 = corrcoef(dtr1,  nb1,'rows','complete');

        % Store correlation coefficients

        cor_pd_p1(i,nnn)  = cc1(1,2);
        cor_pre_p1(i,nnn) = cc2(1,2);
        cor_tem_p1(i,nnn) = cc3(1,2);
        cor_dtr_p1(i,nnn) = cc4(1,2);

    end
end

%% =======================================================
% Legacy code (not used in final analysis)
% =======================================================

% The following section calculates correlations for two
% fixed 40-year periods rather than moving windows.
% Retained for comparison purposes.

for i = 1:3783

    nbb = crnn(:,i);

    ll1 = latlon(i,5);
    ll2 = latlon(i,6);

    latcha = latt-ll2;
    loncha = lonn-ll1;

    latch1 = find(abs(latcha)==min(abs(latcha)));
    lonch1 = find(abs(loncha)==min(abs(loncha)));

    pds = nanmean(nanmean(pdsig(lonch1,latch1,:),1),2);
    pre = nanmean(nanmean(preg(lonch1,latch1,:),1),2);
    tem = nanmean(nanmean(tmpg(lonch1,latch1,:),1),2);

    % First 40-year period
    cc1 = corrcoef(pds(1:40),nbb(1:40),'rows','complete');
    cc2 = corrcoef(pre(1:40),nbb(1:40),'rows','complete');
    cc3 = corrcoef(tem(1:40),nbb(1:40),'rows','complete');

    cor_pd_p1(i,1)  = cc1(1,2);
    cor_pre_p1(i,1) = cc2(1,2);
    cor_tem_p1(i,1) = cc3(1,2);

    % Second 40-year period
    cor_1 = corrcoef(pds(41:80),nbb(41:80),'rows','complete');
    cor_2 = corrcoef(pre(41:80),nbb(41:80),'rows','complete');
    cor_3 = corrcoef(tem(41:80),nbb(41:80),'rows','complete');

    cor_pd_p2(i,1)  = cor_1(1,2);
    cor_pre_p2(i,1) = cor_2(1,2);
    cor_tem_p2(i,1) = cor_3(1,2);

end

%% =======================================================
% Combine results
% =======================================================

tm_cor = [
    cor_pd_p1,  cor_pd_p2,...
    cor_pre_p1, cor_pre_p2,...
    cor_tem_p1, cor_tem_p2
];