function [marker_points] = getSortedMarkerPoints(marker_stats)
    % get marker points in sorted order:
    % 1 = top_left
    % 2 = top_right
    % 3 = bottom_left
    
    n_marker = length(marker_stats);
    
    marker_points = zeros(n_marker, 2);
    
    
    for i = 1:n_marker
        label = marker_stats(i).Label;
        if isstring(label) == false
            label = convertCharsToStrings(label)
        end
        
        if strcmp(label, "top_left") == true
            sorted_index = 1;
        elseif strcmp(label, "top_right") == true
            sorted_index = 2;
        else 
            sorted_index = 3;
        end
        sorted_index
        marker_points(sorted_index,:) = marker_stats(i).Centroid;
        marker_points(sorted_index,:)
    end
end