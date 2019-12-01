% clean up and prepare workspace
clear variables
close all
imtool close all 
clc  

% add functions from subfolder and load settings
addpath(genpath('.\functions'));


% Settings
STARTING_FOLDER = 'C:\Users\Nils Kröll\sciebo\IAR\Klemmkorn Paper\020 Messreihen\001 SSF fein\Bilder Siebboden';
COVERAGE_CLASS_EDGES = [0,eps,0.1,0.9,1];

% Settings Marker
MARKER_RADIUS_MM = 18; % mm
N_MARKER = 3;

% Marker detection
LAB_DISTANCE = 25;
MARKER_MARGIN_CROP = 20; % px

%% LOADING OF IMAGES
fprintf('Loading images ... ')
% get clean image from UI
[img_clean, updated_starting_folder] = readImgFromUI('Select image of clean sieving surface.', STARTING_FOLDER);

% get material image from UI
[img_material, path_material_img, filename_material_img] = readImgFromUI('Select image of sieving surface with clamping grain.', updated_starting_folder);
tic
% the results are saved in the material img folder:
path_results = path_material_img;
clear path_material_img

% the stats are saved in a file that is named after the filename of the material image:
filename_material_img_withoutending = removeFileEndingFromFilename(filename_material_img);

fprintf(' done!\n')

%% MARKER DETECTION
fprintf('Detecting markers ... ')
% load marker colors and get mean marker color and threshold
img_marker = imread('marker/marker_color.jpg');
[threshold_lab_distance, marker_mean_colorvalue_lab] = getMarkerThresholdsLAB(img_marker, LAB_DISTANCE);

% get marker positions and stats
marker_stats_clean = getMarkerStatsLAB(img_clean, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);
marker_stats_material = getMarkerStatsLAB(img_material, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);

fprintf(' done!\n')

img_clean_org = img_clean;
img_material_org = img_material;
%% ROTATE AND CROP IMAGES
fprintf('Rotating  and cropping images ... ')
% align images, s.t. top_left and top_right corner are on one line parallel
% to the x-axis and bottom_left is below that line
img_clean = rotateImageBasedOnMarkerPositions(img_clean, marker_stats_clean);
img_material = rotateImageBasedOnMarkerPositions(img_material, marker_stats_material);

% update marker positions and stats for rotated image
marker_stats_clean = getMarkerStatsLAB(img_clean, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);
marker_stats_material = getMarkerStatsLAB(img_material, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);

% crop images
img_clean = cropImageBasedOnMarkerPositions(img_clean, marker_stats_clean, MARKER_MARGIN_CROP);
img_material = cropImageBasedOnMarkerPositions(img_material, marker_stats_material, MARKER_MARGIN_CROP);
% figure
% imshowpair(img_clean_cropped, img_material_cropped, 'montage')

% update marker positions and stats for rotated and cropped image
marker_stats_clean = getMarkerStatsLAB(img_clean, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);
marker_stats_material = getMarkerStatsLAB(img_material, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);

% % show found markers
% img_clean_with_marker = drawMarkerPositionsOnImg(img_clean, marker_stats_clean);
% img_material_with_marker = drawMarkerPositionsOnImg(img_material, marker_stats_material);
% % figure
% % imshowpair(img_clean_with_marker, img_material_with_marker, 'montage')

% calculate the global calibration factor based on the known radius of the
% marker
global_calibfactor = getGlobalCalibfactor(marker_stats_clean, MARKER_RADIUS_MM);
fprintf(' done!\n')

%% IMAGE REGISTRATION
fprintf('Image registration based on markers ... ')

% STEP 1: Registration based on markers
% Match clean and material image ontop of each other
% get moving and control points
control_points_markers = getSortedMarkerPoints(marker_stats_clean);
moving_points_markers = getSortedMarkerPoints(marker_stats_material);

% find transformation between points
tform_1 = fitgeotrans(moving_points_markers, control_points_markers, 'NonreflectiveSimilarity');

% transform image
img_material = imwarp(img_material,tform_1,'OutputView',imref2d(size(img_clean)));

% STEP 2: User selection
% add preselected points for user

% update marker positions
marker_stats_clean = getMarkerStatsLAB(img_clean, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);
marker_stats_material = getMarkerStatsLAB(img_material, marker_mean_colorvalue_lab, threshold_lab_distance, N_MARKER);

img_material_grid = drawGrid(img_material);
img_clean_grid = drawGrid(img_clean);

% get control points
[control_points_preselected] = getPreselectedControlPoints(marker_stats_clean,img_clean);


% add manually points
[moving_points, control_points] = cpselect(img_material_grid, img_clean_grid, control_points_preselected,control_points_preselected,'Wait',true);



fprintf(' done!\n')



% find transformation between points
n_control_points = length(control_points);

if n_control_points >= 6
    tform_2 = fitgeotrans(moving_points, control_points, 'polynomial', 2);
elseif n_control_points >= 6
    tform_2 = fitgeotrans(moving_points, control_points, 'projective');
else
    tform_2 = fitgeotrans(moving_points, control_points, 'affine');
end
% transform image
img_material = imwarp(img_material,tform_2,'OutputView',imref2d(size(img_clean)));

figure
imshowpair(img_clean, img_material, 'falsecolor')


%% SEGMENTATION
fprintf('Segmentation of both images ... ')
% Segmentation
bw_clean = imbinarize(rgb2gray(img_clean));
bw_material = imbinarize(rgb2gray(img_material));

% figure
% imshowpair(bw_clean, bw_material, 'montage');

fprintf(' done!\n')

%% OVERLAY MASKS
fprintf('Overlaying masks ... ')
overlay_image = overlayMasks(bw_clean, bw_material);

% figure
% imtool(overlay_image)

fprintf(' done!\n')
%% ANALYSIS
fprintf('Analysis of detected clamping grain ... ')

bw_overlay = overlay_image > 0;
object_stats = regionprops(bw_overlay, overlay_image, {'Area', 'PixelValues', 'BoundingBox', 'Centroid'});

% object stats (sieving holes)
object_stats = calcObjectStats(object_stats, global_calibfactor);

% counting of sieving holes with specific coverage
counting_stats = getCountingStats(object_stats, COVERAGE_CLASS_EDGES);

% overall stats
overall_stats = calcOverallStats(object_stats, global_calibfactor);

fprintf(' done!\n')

%% SAVE RESULTS
fprintf('Saving results ... ')
results_folder_name = ['results_', filename_material_img_withoutending];
path_results_subfolder = fullfile(path_results, results_folder_name);

mkdir(path_results_subfolder);

% create new subfolder
% save stats as .xlsx
filename_xlsx = ['stats_', filename_material_img_withoutending, '.xlsx'];
saveResultsAsXLSX(object_stats, overall_stats, counting_stats, fullfile(path_results_subfolder, filename_xlsx));

% save images
% overlay image
filename_overlay_img = ['overlay_', filename_material_img_withoutending, '.png'];
imwrite(overlay_image, fullfile(path_results_subfolder, filename_overlay_img));

%  cropped and rotate clean image
filename_img_clean = ['img_clean_', filename_material_img_withoutending, '.png'];
imwrite(img_clean, fullfile(path_results_subfolder, filename_img_clean));

filename_img_clampinggrain = ['img_clampinggrain_', filename_material_img_withoutending, '.png'];
imwrite(img_material, fullfile(path_results_subfolder, filename_img_clampinggrain));

% binary images
filename_bw_clean = ['bw_clean_', filename_material_img_withoutending, '.png'];
imwrite(bw_clean, fullfile(path_results_subfolder, filename_bw_clean));

filename_bw_clampinggrain = ['bw_clampinggrain_', filename_material_img_withoutending, '.png'];
imwrite(bw_material, fullfile(path_results_subfolder, filename_bw_clampinggrain));


fprintf(' done!\n')
fprintf('Results:\n')
dispLinkToFolder(path_results_subfolder)
toc
