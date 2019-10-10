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
img_marker = imread('marker/marker_color.jpg');
marker_thresholds = getMarkerThresholds(img_marker, 4);

% marker thresholding
structuring_element_size = (2./3456) .* size(img_clean,2);
structuring_element = strel('sphere', 4);
[bw_marker_cleanimg, bw_channelwise] = getBinaryMarkerImage(img_clean, marker_thresholds);%, structuring_element);
clear structuring_element_size structuring_element

marker_stats = regionprops(bw_marker_cleanimg, {'Area', 'BoundingBox', 'Centroid'});

% sort by area to find markers (biggest elements)
[~, sort_index] = sort([marker_stats.Area], 'descend');
marker_stats = marker_stats(sort_index);
marker_stats = marker_stats(1:N_MARKER);

% Get global_calibfactor
% get boundingbox measurements = radii
for i = 1:N_MARKER
    radii_x(i,1) = marker_stats(i).BoundingBox(3);
    radii_y(i,1) = marker_stats(i).BoundingBox(4);
end

% combine x and y radii
radii = [radii_x;radii_y];
clear radii_x radii_y

median_radius_px = median(radii);
global_global_calibfactor = MARKER_RADIUS_MM ./ median_radius_px; % [mm/px]









% bw_marker_materialimg = getBinaryMarkerImage(img_material, marker_thresholds);

% imshowpair(bw_marker_cleanimg, bw_marker_materialimg)



%% MATCHING

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

%% ANALYSIS
[stats_clean] = addRelativeCoverageToStats(stats_clean);


% overall stats
overall_stats.TotalFreeAreaCleanImage_px = sum([stats_clean.Area]);
overall_stats.TotalFreeAreaMaterialImage_px = sum([stats_clean.AreaMaterialImage]);
overall_stats.TotalCoveredArea_px = overall_stats.TotalFreeAreaCleanImage_px - overall_stats.TotalFreeAreaMaterialImage_px;

% counting of sieving holes with specific coverage
counting_stats = getCountingStats(stats_clean, COVERAGE_CLASS_EDGES);


% todo: get/calc calibration factor

% prepare stats for export to .xlsx - file
object_stats_export = prepareObjectStatsForExport(stats_clean, global_calibfactor);
overall_stats_export = prepareOverallStatsForExport(overall_stats, global_calibfactor);
counting_stats_export = counting_stats;

% export stats as .xlsx
saveResultsAsXLSX(object_stats_export, overall_stats_export, counting_stats_export, fullfilename_xlsx)

fprintf('Results:\n')
dispLinkToFolder(fullfilename_xlsx)
