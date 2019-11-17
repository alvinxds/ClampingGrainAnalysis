% clean up and prepare workspace
clear variables
close all
imtool close all 
clc  

% add functions from subfolder and load settings
addpath(genpath('.\functions'));
load('settings.mat')
load('marker/markerSettings.mat')

STARTING_FOLDER = 'C:\Users\Nils Kr�ll\sciebo\IAR\Kay Johnen\Klemmkornauswertung'; % replace by folder from UI later on


%% Loading of images

% get clean image from UI
[img_clean, updated_starting_folder] = readImgFromUI('Select image of clean sieving surface.', STARTING_FOLDER);

% get material image from UI
[img_material, path_material_img, filename_material_img] = readImgFromUI('Select image of sieving surface with clamping grain.', updated_starting_folder);
tic
% the results are saved in the material img folder:
path_xlsx = path_material_img;
clear path_material_img

% the stats are saved in a file that is named after the filename of the
% material image:
filename_xlsx = getXLSXFilename(filename_material_img);

% fullfile is then given by:
fullfilename_xlsx = fullfile(path_xlsx, filename_xlsx);

%% Marker detection
% load marker colors and get thresholds
img_marker_color = imread('marker/marker_color.jpg');
marker_thresholds = getMarkerThresholds(img_marker_color, 6);

% get marker positions and stats
marker_stats_clean = getMarkerStats(img_clean, marker_thresholds, N_MARKER);
marker_stats_material = getMarkerStats(img_material, marker_thresholds, N_MARKER);


% show found markers
img_clean_with_marker = drawMarkerPositionsOnImg(img_clean,marker_stats_clean);
img_material_with_marker = drawMarkerPositionsOnImg(img_material,marker_stats_material);
figure;
imshowpair(img_clean_with_marker, img_material_with_marker, 'montage')

%% Crop images
% align images, s.t. top_left and top_right corner are on one line parallel
% to the x-axis and bottom_left is below that line
img_clean_rotated = rotateImageBasedOnMarkerPositions(img_clean, marker_stats_clean);
img_material_rotated = rotateImageBasedOnMarkerPositions(img_material, marker_stats_material);

% update marker positions and stats for rotated image
marker_stats_clean = getMarkerStats(img_clean_rotated, marker_thresholds, N_MARKER);
marker_stats_material = getMarkerStats(img_material_rotated, marker_thresholds, N_MARKER);

% show found markers
img_clean_with_marker = drawMarkerPositionsOnImg(img_clean_rotated,marker_stats_clean);
img_material_with_marker = drawMarkerPositionsOnImg(img_material_rotated,marker_stats_material);
figure;
imshowpair(img_clean_with_marker, img_material_with_marker, 'montage')

% crop images
img_clean_cropped = cropImageBasedOnMarkerPositions(img_clean_rotated, marker_stats_clean);
img_material_cropped = cropImageBasedOnMarkerPositions(img_material_rotated, marker_stats_material);
figure;
imshowpair(img_clean_cropped, img_material_cropped, 'montage');

% update marker positions and stats for rotated and cropped image
marker_stats_clean = getMarkerStats(img_clean_cropped, marker_thresholds, N_MARKER);
marker_stats_material = getMarkerStats(img_material_cropped, marker_thresholds, N_MARKER);

% calculate the global calibration factor based on the known radius of the
% marker
global_calibfactor_clean = getGlobalCalibfactor(marker_stats_clean, MARKER_RADIUS_MM);
global_calibfactor_material = getGlobalCalibfactor(marker_stats_material, MARKER_RADIUS_MM);


%% Image registration: Match clean and material image ontop of each other
% get moving and control points
control_points = getSortedMarkerPoints(marker_stats_clean);
moving_points = getSortedMarkerPoints(marker_stats_material);

% find transformation between points
tform = fitgeotrans(moving_points, control_points, 'nonreflectivesimilarity');

% transform image

img_material_cropped_warped = imwarp(img_material_cropped,tform,'OutputView',imref2d(size(img_clean_cropped)));


%% SEGMENTATION

% Segmentation
bw_clean = imbinarize(rgb2gray(img_clean_cropped));
bw_material = imbinarize(rgb2gray(img_material_cropped_warped));
figure;
imshowpair(bw_clean, bw_material, 'falsecolor');


%% MATCHING

stats_to_be_calculated = {'Centroid', 'Area'};
stats_clean = regionprops(bw_clean, stats_to_be_calculated);
stats_material = regionprops(bw_material, stats_to_be_calculated);

% apply tform for material centroids
stats_material_transformed = applyFitGeoTransformation(stats_material, tform);

[stats_clean,stats_material_transformed] = addNearestRegionToStats(stats_clean,stats_material_transformed);
[stats_clean,stats_material_transformed] = addAreasOfCorrespondingRegionToStats(stats_clean,stats_material_transformed);

% visualisation
scatterCentroids(stats_clean,stats_material_transformed);

%% ANALYSIS

% object stats (sieving holes)
object_stats = calcObjectStats(stats_clean, global_calibfactor_clean, global_calibfactor_material);

% counting of sieving holes with specific coverage
counting_stats = getCountingStats(object_stats, COVERAGE_CLASS_EDGES);

% overall stats
overall_stats = calcOverallStats(object_stats);


% export stats as .xlsx
saveResultsAsXLSX(object_stats, overall_stats, counting_stats, fullfilename_xlsx)

fprintf('Results:\n')
dispLinkToFolder(fullfilename_xlsx)
toc
