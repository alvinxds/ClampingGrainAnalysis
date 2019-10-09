% clean up and prepare workspace
clear variables
close all
imtool close all 
clc  

% add functions from subfolder and load settings
addpath(genpath('.\functions'));
load('settings.mat')

FOLDER_TO_SAVE_XLSX = 'Z:\git\Klemmkornauswertung'; % replace by folder from UI later on
XLS_FILENAME = 'stats.xlsx';
fullfilename_xlsx = fullfile(FOLDER_TO_SAVE_XLSX, XLS_FILENAME);
CALIBFACTOR = 2; %[mm/px]

% Loading of images

% get clean image from UI
img_clean = readImgFromUI('Select image of clean sieving surface.');

% get material image from UI
[img_material, path_material_img, filename_material_img] = readImgFromUI('Select image of sieving surface with clamping grain.');

% the results are saved in the material img folder:
path_xlsx = path_material_img;
clear path_material_img

% the stats are saved in a file that is named after the material image
% filename

filename_xlsx = getXLSXFilename(filename_material_img);

% fullfile is then given by:




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
overall_stats.TotalFreeAreaCleanImage_px = sum([stats_clean.Area]);
overall_stats.TotalFreeAreaMaterialImage_px = sum([stats_clean.AreaMaterialImage]);
overall_stats.TotalCoveredArea_px = overall_stats.TotalFreeAreaCleanImage_px - overall_stats.TotalFreeAreaMaterialImage_px;

% counting of sieving holes with specific coverage
counting_stats = getCountingStats(stats_clean, COVERAGE_CLASS_EDGES);


% todo: get/calc calibration factor

% prepare stats for export to .xlsx - file
object_stats_export = prepareObjectStatsForExport(stats_clean, CALIBFACTOR);
overall_stats_export = prepareOverallStatsForExport(overall_stats, CALIBFACTOR);
counting_stats_export = counting_stats;

% export stats as .xlsx
saveResultsAsXLSX(object_stats_export, overall_stats_export, counting_stats_export, fullfilename_xlsx)

fprintf('Results:\n')
dispLinkToFolder(fullfilename_xlsx)
