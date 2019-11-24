function [marker_thresholds] = getMarkerThresholdsHSV(img_marker_hsv, p)

    p_percent = p .* 100;
        
    n_channels = size(img_marker_hsv,3);
   
    % reshape colors as [R G B] matrix of size(n_pixels,n_channels)
    colors_marker = double(reshape(img_marker_hsv,[],n_channels,1));
    
    % sort each HSV Channel by size
    for i = 1:n_channels
        colors_marker_sorted(:,i) = sort(colors_marker(:,i), 'ascend');        
    end
    
    % Upper and lower thresholds by percentiles
    for i = 1:n_channels % go trough all RGB channels
        % lower threshold
        marker_thresholds(i).lower = prctile(colors_marker_sorted(:,i), p_percent);

        % upper threshold
        marker_thresholds(i).upper = prctile(colors_marker_sorted(:,i), (100 - p_percent));
    end

end

