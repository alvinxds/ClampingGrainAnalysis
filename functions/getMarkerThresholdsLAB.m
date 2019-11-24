function [threshold_lab_distance, marker_mean_colorvalue] = getMarkerThresholdsLAB(img_marker_rgb, N_TIMES_MAX_DISTANCE)
    % convert image to Lab color space
    marker_lab = rgb2lab(img_marker_rgb);
    
    % reshape into color vector
    marker_lab_vec = reshape(marker_lab, [], 3, 1);
    
    % mean Lab values of marker image
    marker_mean_colorvalue = mean(marker_lab_vec, 1);
    
    % distances for all pixels in marker image to mean color value
    distances_to_mean_marker = distanceLABToMean(marker_lab_vec, marker_mean_colorvalue);
    
    % derive distance for threshold
    max_lab_distance_to_mean_marker = max(distances_to_mean_marker);
    
    threshold_lab_distance = N_TIMES_MAX_DISTANCE .* max_lab_distance_to_mean_marker;
    
end

