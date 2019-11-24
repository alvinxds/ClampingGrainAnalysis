function [marker_stats, bw_marker_cleanimg] = getMarkerStatsHSV(img_clean_hsv, marker_thresholds_hsv, N_MARKER)
    % marker thresholding
    bw_marker_cleanimg = segmentedBasedOnThresholdsHSV(img_clean_hsv, marker_thresholds_hsv);
    clear structuring_element_size structuring_element

    marker_stats = regionprops(bw_marker_cleanimg, {'Area', 'BoundingBox'});

    % sort by area to find markers (biggest elements)
    [~, sort_index] = sort([marker_stats.Area], 'descend');
    marker_stats = marker_stats(sort_index);
    marker_stats = marker_stats(1:N_MARKER);
    
    % add centroid = center of BoundingBox (BB)
    marker_stats = addMarkerCentroidBB(marker_stats);
    
    % identify topleft, topright and bottomright marker
    marker_stats = addMarkerLabels(marker_stats, size(img_clean_hsv,1));   
    
end

function [marker_stats] = addMarkerCentroidBB(marker_stats)
    
    n_marker = length(marker_stats);
    
    for i = 1:n_marker
        % get center of bounding box
        bb_topleft_corner = marker_stats(i).BoundingBox(1:2);
        bb_width_x = marker_stats(i).BoundingBox(3);
        bb_height_y = marker_stats(i).BoundingBox(4);
        bb_centroid = bb_topleft_corner + [bb_width_x, bb_height_y]./2;
        
        % add to stats
        marker_stats(i).Centroid = bb_centroid;      
    end
end