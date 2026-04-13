clc
clear

%% Load input data
load('fig.S9_sample_size.mat')
load('fig.S9_infor.mat', 'infor')
load('fig.S9_infor.mat', 'latlon')

% Extract species codes
spec = infor(:,4);
specc = unique(spec);

% Keep species with sample size > 20
sssp = specc(samplesize > 20);
nnn = samplesize(samplesize > 20);

% Longitude and latitude of tree-ring sites
lllon = latlon(:,5);
lllat = latlon(:,6);

% Read mountain distribution raster
[A,R] = geotiffread('mountian2.tif');

%% Plot background mountain map
figure

h1 = axesm('MapProjection','miller', ...
           'Grid','on', ...
           'MapLatLimit',[-60,75], ...
           'MapLonLimit',[-180 180]);

framem('on');
gridm('on');
mlabel('south');
plabel('west');

setm(gca,'MLineLocation',30)   % Set meridian interval to 30бу
setm(gca,'PLineLocation',10)   % Set parallel interval to 10бу
setm(gca,'MLabelLocation',30)  % Set longitude label interval to 30бу
setm(gca,'PLabelLocation',10)  % Set latitude label interval to 10бу

load coastlines.mat
load ccmap.mat

% Build latitude and longitude grid for raster display
[lati, longi] = meshgrid(-55.9:0.56:83.52, -179.79:0.5:180);

% Rotate raster to match map orientation
mn = rot90(double(A), 3);

% Set background values
mn(mn == 255) = nan;
mn(mn < 255) = 1;

% Plot mountain raster
pcolorm(lati, longi, mn);

% Overlay coastlines
hold on
plotm(coastlat, coastlon, 'black')

% Set grayscale colormap
colormap(gray)

% Set font size for map labels
setm(gca,'FontSize',14)

%% Plot tree-ring sites by species
h1 = axesm('MapProjection','miller', ...
           'Grid','on', ...
           'MapLatLimit',[-60,75], ...
           'MapLonLimit',[-180 180]);

framem('on');
gridm('on');
mlabel('south');
plabel('west');

setm(gca,'MLineLocation',30)   % Set meridian interval to 30бу
setm(gca,'PLineLocation',10)   % Set parallel interval to 10бу
setm(gca,'MLabelLocation',30)  % Set longitude label interval to 30бу
setm(gca,'PLabelLocation',10)  % Set latitude label interval to 10бу

load coastlines.mat
load ccmap.mat

% Plot coastlines
plotm(coastlat, coastlon, 'black')
hold on

% Generate color map for 41 species
cmap = colormap(hsv(41));

for ss = 1:41
    ll = sssp(ss);

    % Find all records belonging to the current species
    [m,n] = find(strcmp(ll, spec));

    % Extract longitude and latitude
    llllon = lllon(m);
    llllat = lllat(m);

    % Plot site locations
    s1 = scatterm(llllat, llllon, 20, cmap(ss,:), 'filled');

    % Optional transparency settings
    % distfromzero = sqrt(lllat.^2 + lllon.^2);
    % s1.AlphaData = distfromzero;
    % s1.MarkerFaceAlpha = 0.1;
end

colormap(cmap)

% Add colorbar with species labels
cb = colorbar('southoutside');   % place colorbar below the map
ytickss = 0.02:1/41:1;
set(cb, 'YTick', ytickss, 'YTickLabel', sssp)

% Set font size
set(gca,'FontSize',14)
setm(gca,'FontSize',14)


%% Plot shift-rate sites
clc
clear

load("D:\ITRDB_5000\Mountain_site\shift_species.mat")

% Select records with valid shift-rate index
mmm = find(idx == 1);

% Remove problematic records
mmm([143,271,272,273], :) = [];

% Extract relevant longitude/latitude columns
lll = shiftlon(mmm, 3:7);

% Corresponding species list
sppp = specc(mmm);
sp = unique(sppp);

figure
cmap = colormap;

h1 = axesm('MapProjection','miller', ...
           'Grid','on', ...
           'MapLatLimit',[-60,75], ...
           'MapLonLimit',[-180 180]);

framem('on');
gridm('on');
mlabel('south');
plabel('west');

setm(gca,'MLineLocation',30)   % Set meridian interval to 30бу
setm(gca,'PLineLocation',10)   % Set parallel interval to 10бу
setm(gca,'MLabelLocation',30)  % Set longitude label interval to 30бу
setm(gca,'PLabelLocation',10)  % Set latitude label interval to 10бу

load coastlines.mat

% Generate color map for 99 species
cmap = colormap(hsv(99));

for ss = 1:99
    ll = sp(ss);

    % Find all records belonging to the current species
    [m,n] = find(strcmp(ll, sppp));

    % Extract longitude and latitude of shift records
    llllon = lll(m,3);
    llllat = lll(m,4);

    % Plot shift-rate site locations
    s1 = scatterm(llllat, llllon, 50, cmap(ss,:), 'filled');

    % Optional transparency settings
    % distfromzero = sqrt(lllat.^2 + lllon.^2);
    % s1.AlphaData = distfromzero;
    % s1.MarkerFaceAlpha = 0.1;
end

hold on

% Plot coastline
plotm(lat, long, 'black')

% Add colorbar with species labels
cb = colorbar('southoutside');   % place colorbar below the map
ytickss = 0.02:1/99:1;
set(cb, 'YTick', ytickss, 'YTickLabel', sp)

% Set font size
set(gca,'FontSize',14)
setm(gca,'FontSize',14)
