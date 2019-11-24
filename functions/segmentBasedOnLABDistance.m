function [bw] = segmentBasedOnLABDistance(img_rgb, marker_mean_colorvalue, threshhold_distance)    
    % convert both images to Lab color space
    img_lab = rgb2lab(img_rgb);
    
    % reshape into color vector
    img_lab_vec = reshape(img_lab, [], 3, 1);
    
    % segment image

    % distance to mean marker  
    distance_img_to_maker =  distanceLABToMean(img_lab_vec, marker_mean_colorvalue);
    
    % get binary image: all pixels with distance < threshold distance
    bw_vec = distance_img_to_maker < threshhold_distance;
    
    bw = reshape(bw_vec, size(img_lab, 1), size(img_lab, 2), 1);
    
end
