% clean up and prepare workspace
clear variables
close all
imtool close all 
clc  

% add functions from subfolder and load settings
addpath(genpath('.\functions'));


% MATCHING

% we start here with a binary image and merge the two program parts later
% on


% load test binary images (remove later)
bw_clean = imread('bw_test_clean.png');
bw_material = imread('bw_test_material.png');
bw_material = imbinarize(bw_material); % convert from GIMP

imshowpair(bw_clean, bw_material, 'montage')


stats_to_be_calculated = {'Centroid', 'Area'};

stats_clean = regionprops(bw_clean, stats_to_be_calculated);
stats_material = regionprops(bw_material, stats_to_be_calculated);

[stats_clean,stats_material] = addNearestRegionToStats(stats_clean,stats_material);
[stats_clean,stats_material] = addAreasOfCorrespondingRegionToStats(stats_clean,stats_material);

% ANALYSIS
[stats_clean] = addRelativeCoverageToStats(stats_clean);


% overall stats
overall_stats
