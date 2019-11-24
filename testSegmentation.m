% clean up and prepare workspace
clear variables
close all
imtool close all 
clc  

% add functions from subfolder and load settings
addpath(genpath('.\functions'));

STARTING_FOLDER = 'C:\Users\Nils Kr�ll\sciebo\IAR\Klemmkornauswertung\Testbilder Programmentwicklung\Bilder Testsiebung 20191118-1605';
N_MARKER = 3;

% get clean image from UI
[img_clean, updated_starting_folder] = readImgFromUI('Select image of clean sieving surface.', STARTING_FOLDER);

%% Marker detection
% load marker colors and get thresholds
img_marker = imread('marker/marker_color.jpg');

N_TIMES_MAX_DISTANCE = 4;

[threshold_lab_distance, marker_mean_colorvalue] = getMarkerThresholdsLAB(img_marker, N_TIMES_MAX_DISTANCE);

% get marker positions and stats
[marker_stats, bw_marker] = getMarkerStatsLAB(img_clean, marker_mean_colorvalue, threshold_lab_distance, N_MARKER);

img_clean_lab = rgb2lab(img_clean);

img_clean_lab_vec = reshape(img_clean_lab, [], 3, 1);
bw_marker_vec = reshape(bw_marker, [], 1);

for i = 1:3
    colors_as_marker_vec(:,i) = img_clean_lab_vec(bw_marker == 1, i);
    colors_as_nonmarker_vec(:,i) = img_clean_lab_vec(bw_marker == 0, i);
end

bw_marker_pre = bwareaopen(bw_marker, 100);

figure
imshow(bw_marker);

figure
scatter(colors_as_marker_vec(:,2),  colors_as_marker_vec(:,3),10, [1 0 0]);
hold on
scatter(colors_as_nonmarker_vec(:,2),  colors_as_nonmarker_vec(:,3),10, [0.3 0.3 0.3]);
scatter(marker_mean_colorvalue(:,2), marker_mean_colorvalue(:,3), 50, [0 1 1], 'filled');
legend({'Marker', 'Non Marker', 'Mean Marker'})
xlabel('a*')
ylabel('b*')
title('Marker detection in L*a*b* colorspace')
axis equal

figure
imshow(bw_marker);
% show found markers
img_clean_with_marker = drawMarkerPositionsOnImg(img_clean,marker_stats);

figure;
imshow(img_clean_with_marker)
