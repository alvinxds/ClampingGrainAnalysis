clear variables
close all
clc

STARTING_FOLDER = 'C:\Users\nkroell\sciebo\IAR\Kay Johnen\Klemmkorn';

% read clean image
[img_file_clean,img_path_clean] = uigetfile(fullfile(STARTING_FOLDER,'*.jpg'),'Select file with clean sieving surface.');
img_clean = imread(fullfile(img_path_clean,img_file_clean));
clear img_file_clean img_path_clean

% read material image
[img_file_material,img_path_material] = uigetfile(fullfile(STARTING_FOLDER,'*.jpg'),'Select file with sieving surface covered with material.');
img_material = imread(fullfile(img_path_material,img_file_material));
clear img_file_material img_path_material

% make copy of org image
img_clean_org = img_clean;
img_material_org = img_material;

% crop images with imcrop tool
img_clean = imcrop(img_clean);
img_material = imcrop(img_material);

img_clean = rgb2gray(img_clean);
img_material = rgb2gray(img_material);

% align images together
% todo (Marker?)

% image segmentation

bw_clean = imbinarize(img_clean);
bw_material = imbinarize(img_material);

figure
subplot(1,2,1)
imshow(img_clean)
title('IMG: Clean sieving surface')
subplot(1,2,2)
imshow(img_material)
title('IMG: Sieving surface covered with material')

figure
subplot(1,2,1)
imshow(bw_clean)
title('BW: Clean sieving surface')
subplot(1,2,2)
imshow(bw_material)
title('BW: Sieving surface covered with material')

[selected_moving_points, selected_fixed_points] = cpselect(img_material, img_clean, 'Wait', true);

tform = fitgeotrans(selected_moving_points, selected_fixed_points, 'affine');

img_material_registered = imwarp(img_material, tform, 'OutputView', imref2d(size(img_clean)));
figure
imshowpair(img_clean, img_material_registered, 'blend');