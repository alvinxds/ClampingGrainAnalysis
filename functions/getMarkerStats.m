function [marker_stats] = getMarkerStats(img_clean, marker_thresholds, N_MARKER)
    % marker thresholding
    STRUCTURING_ELEMENT_SIZE = round((2./3456) .* size(img_clean,2));
    structuring_element = strel('sphere', STRUCTURING_ELEMENT_SIZE);
    [bw_marker_cleanimg, bw_channelwise] = getBinaryMarkerImage(img_clean, marker_thresholds, structuring_element);
    clear structuring_element_size structuring_element

    marker_stats = regionprops(bw_marker_cleanimg, {'Area', 'BoundingBox', 'Centroid'});

    % sort by area to find markers (biggest elements)
    [~, sort_index] = sort([marker_stats.Area], 'descend');
    marker_stats = marker_stats(sort_index);
    marker_stats = marker_stats(1:N_MARKER);
end

