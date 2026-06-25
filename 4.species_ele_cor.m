%% --------------------------------------------------------
% Methodological note
%
% Elevational dependence of climate sensitivity was
% quantified as the Pearson correlation between site
% elevation and climate-growth correlation coefficients.
% To minimize the influence of unequal sample sizes among
% species, 20 sites were randomly selected for each
% species, and the analysis was repeated 100 times.
% Mean bootstrap correlations and their standard
% deviations were used in subsequent analyses.
% --------------------------------------------------------
% =========================================================
% Script: species_ele_cor.m
%
% Purpose:
% Quantify elevational dependence of climate-growth
% relationships for each species across multiple
% moving time windows.
%
% For each species:
%   1. Randomly sample 20 sites.
%   2. Calculate the correlation between elevation and
%      climate-growth sensitivity.
%   3. Repeat 100 times to estimate the mean correlation
%      and sampling uncertainty.
%
% Climate variables:
%   - PDSI
%   - Precipitation
%   - Temperature
%   - Diurnal Temperature Range (DTR)
% =========================================================


%% --------------------------------------------------------
% Load datasets
% --------------------------------------------------------

% Moving-window climate-growth correlations
load('temporal_cor_period.mat')

% Site elevation
load('elee.mat')

% Species information
load('infor.mat')

% Number of sites available for each species
load('sample_size.mat')


%% --------------------------------------------------------
% Species information
% --------------------------------------------------------

% Species codes for all tree-ring sites
spec = infor(1:end-1,4);

% Unique species list
specu = unique(spec);

% Retain species represented by more than 20 sites
ssp = specu(samplesize > 20);


%% --------------------------------------------------------
% Estimate elevational dependence of climate sensitivity
% --------------------------------------------------------

for nnn = 1:11          % Moving time windows

    for ss = 1:41       % Species

        %-------------------------------------------------
        % Select current species
        %-------------------------------------------------

        ll = ssp(ss);

        % Indices of all sites belonging to this species
        [m,~] = find(strcmp(ll,spec));

        % Elevation
        elevv = elee(m,1);

        % Climate-growth correlations
        pdcr  = cor_pd_p1(m,nnn);
        precr = cor_pre_p1(m,nnn);
        temcr = cor_tem_p1(m,nnn);
        dtrcr = cor_dtr_p1(m,nnn);

        %-------------------------------------------------
        % Bootstrap resampling
        %-------------------------------------------------

        for pp = 1:100

            % Randomly select 20 sites
            indd = randperm(numel(pdcr),20);

            elevat = elevv(indd);

            pd_cr1  = pdcr(indd);
            pre_cr1 = precr(indd);
            tem_cr1 = temcr(indd);
            dtr_cr1 = dtrcr(indd);

            %---------------------------------------------
            % Correlation between elevation and climate
            % sensitivity
            %---------------------------------------------

            dd1 = corrcoef(elevat,pd_cr1 ,'rows','complete');
            dd2 = corrcoef(elevat,pre_cr1,'rows','complete');
            dd3 = corrcoef(elevat,tem_cr1,'rows','complete');
            dd4 = corrcoef(elevat,dtr_cr1,'rows','complete');

            % Store bootstrap results
            pdsi_cr(ss,nnn,pp) = dd1(1,2);
            pre_cr(ss,nnn,pp)  = dd2(1,2);
            tem_cr(ss,nnn,pp)  = dd3(1,2);
            dtr_cr(ss,nnn,pp)  = dd4(1,2);

        end

    end

end


%% --------------------------------------------------------
% Calculate bootstrap mean
% --------------------------------------------------------

pdsi_cr_m = mean(pdsi_cr,3);
pre_cr_m  = mean(pre_cr,3);
tem_cr_m  = mean(tem_cr,3);
dtr_cr_m  = mean(dtr_cr,3);


%% --------------------------------------------------------
% Calculate bootstrap standard deviation
% --------------------------------------------------------

pd_cr_sd  = std(pdsi_cr,0,3);
pre_cr_sd = std(pre_cr,0,3);
tem_cr_sd = std(tem_cr,0,3);
dtr_cr_sd = std(dtr_cr,0,3);


%% --------------------------------------------------------
% Save results
% --------------------------------------------------------

save('species_elevational_dependence.mat', ...
    'pdsi_cr', 'pre_cr', 'tem_cr', 'dtr_cr', ...
    'pdsi_cr_m', 'pre_cr_m', 'tem_cr_m', 'dtr_cr_m', ...
    'pd_cr_sd', 'pre_cr_sd', 'tem_cr_sd', 'dtr_cr_sd');