function [bw] = segmentBasedOnLABDistance(img_rgb, marker_mean_colorvalue, threshhold_distance)   

    n_pixels_height = size(img_rgb, 1);
    n_pixels_width = size(img_rgb, 2);

    % convert image to L*a*b* color space
    img_lab = rgb2lab(img_rgb);
    
    % reshape into color vector
    img_lab_vec = reshape(img_lab, [], 3, 1);

    % distance to mean marker  
    distance_img_to_maker =  distanceLABToMean(img_lab_vec, marker_mean_colorvalue);
    
    % get binary image: all pixels with distance < threshold distance
    bw_vec = distance_img_to_maker < threshhold_distance;
    
    % get final bw  by reshaping vector into original matrix form
    bw = reshape(bw_vec, n_pixels_height, n_pixels_width, 1);  
end
