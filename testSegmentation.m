% clean up and prepare workspace
clear variables
close all
imtool close all 
clc  

% add functions from subfolder and load settings
addpath(genpath('.\functions'));
load('settings.mat')
load('marker/markerSettings.mat')

STARTING_FOLDER = 'C:\Users\Nils Kröll\sciebo\IAR\Klemmkornauswertung\Testbilder Programmentwicklung\Bilder Testsiebung 20191118-1605';
N_MARKER = 3;

% get clean image from UI
[img_clean, updated_starting_folder] = readImgFromUI('Select image of clean sieving surface.', STARTING_FOLDER);

%% Marker detection
% load marker colors and get thresholds
img_marker = imread('marker/marker_color.jpg');

N_TIMES_MAX_DISTANCE = 2.5;

[threshold_lab_distance, marker_mean_colorvalue] = getMarkerThresholdsLAB(img_marker, N_TIMES_MAX_DISTANCE);

% get marker positions and stats
[marker_stats, bw_marker] = getMarkerStatsLAB(img_clean, marker_mean_colorvalue, threshold_lab_distance, N_MARKER);

figure
imshow(bw_marker);
% show found markers
img_clean_with_marker = drawMarkerPositionsOnImg(img_clean,marker_stats);

figure;
imshow(img_clean_with_marker)

