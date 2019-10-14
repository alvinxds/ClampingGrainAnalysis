% clean up and prepare workspace
clear variables
close all
imtool close all 
clc  

% add functions from subfolder and load settings
addpath(genpath('.\functions'));
load('settings.mat')

N_MARKER = 3;
MARKER_RADIUS_MM = 18; %mm

FOLDER_TO_SAVE_XLSX = 'Z:\git\Klemmkornauswertung'; % replace by folder from UI later on

global_calibfactor = 2; %[mm/px], replace automatically later on

%% Loading of images

% get clean image from UI
img_clean = readImgFromUI('Select image of clean sieving surface.', STARTING_FOLDER);

% get material image from UI
[img_material, path_material_img, filename_material_img] = readImgFromUI('Select image of sieving surface with clamping grain.', STARTING_FOLDER);

% the results are saved in the material img folder:
path_xlsx = path_material_img;
clear path_material_img

% the stats are saved in a file that is named after thefilename of the
% material image:
filename_xlsx = getXLSXFilename(filename_material_img);

% fullfile is then given by:
fullfilename_xlsx = fullfile(path_xlsx, filename_xlsx);

%% Marker detection
% load marker colors and get thresholds
img_marker_color = imread('marker/marker_color.jpg');
marker_thresholds = getMarkerThresholds(img_marker_color, 4);

marker_stats_clean = getMarkerStats(img_clean, marker_thresholds, N_MARKER);
marker_stats_material = getMarkerStats(img_material, marker_thresholds, N_MARKER);

global_calibfactor = getGlobalCalibfactor(marker_stats_clean, MARKER_RADIUS_MM);


[img_clean_with_marker] = drawMarkerPositionsOnImg(img_clean,marker_stats_clean);
[img_material_with_marker] = drawMarkerPositionsOnImg(img_material,marker_stats_material);
figure
imshowpair(img_clean_with_marker, img_material_with_marker, 'montage')


%% Image registration
% get moving and control points
control_points = getSortedMarkerPoints(marker_stats_clean);
moving_points = getSortedMarkerPoints(marker_stats_material);

% find transformation between points
tform = fitgeotrans(moving_points, control_points, 'nonreflectivesimilarity');


%% SEGMENTATION




%% MATCHING
% we start here with a binary image and merge the two program parts later
% on

stats_to_be_calculated = {'Centroid', 'Area'};
stats_clean = regionprops(bw_clean, stats_to_be_calculated);
stats_material = regionprops(bw_material, stats_to_be_calculated);



[stats_clean,stats_material] = addNearestRegionToStats(stats_clean,stats_material);
[stats_clean,stats_material] = addAreasOfCorrespondingRegionToStats(stats_clean,stats_material);

%% ANALYSIS
[stats_clean] = addRelativeCoverageToStats(stats_clean);

% overall stats
overall_stats.TotalFreeAreaCleanImage_px = sum([stats_clean.Area]);
overall_stats.TotalFreeAreaMaterialImage_px = sum([stats_clean.AreaMaterialImage]);
overall_stats.TotalCoveredArea_px = overall_stats.TotalFreeAreaCleanImage_px - overall_stats.TotalFreeAreaMaterialImage_px;

% counting of sieving holes with specific coverage
counting_stats = getCountingStats(stats_clean, COVERAGE_CLASS_EDGES);


% prepare stats for export to .xlsx - file
object_stats_export = prepareObjectStatsForExport(stats_clean, global_calibfactor);
overall_stats_export = prepareOverallStatsForExport(overall_stats, global_calibfactor);
counting_stats_export = counting_stats;

% export stats as .xlsx
saveResultsAsXLSX(object_stats_export, overall_stats_export, counting_stats_export, fullfilename_xlsx)

fprintf('Results:\n')
dispLinkToFolder(fullfilename_xlsx)
