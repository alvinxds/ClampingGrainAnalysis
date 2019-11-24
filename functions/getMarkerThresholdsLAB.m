function [threshold_lab_distance, marker_mean_colorvalue] = getMarkerThresholdsLAB(img_marker_rgb, n_times_lab_distance)
    % convert image to L*a*b* color space
    img_marker_lab = rgb2lab(img_marker_rgb);
    
    % reshape into color vector
    img_marker_lab_vec = reshape(img_marker_lab, [], 3, 1);
    
    % mean L*a*b* values of marker image
    marker_mean_colorvalue = mean(img_marker_lab_vec, 1);
    
    % distances for all pixels in marker image to mean color value
    lab_distances_to_mean_marker_color = distanceLABToMean(img_marker_lab_vec, marker_mean_colorvalue);
    
    % max distance
    max_lab_distance_to_mean_marker_color = max(lab_distances_to_mean_marker_color);
    
    % derive threshold:
    threshold_lab_distance = n_times_lab_distance .* max_lab_distance_to_mean_marker_color;    
end