function [bw_marker, bw_channelwise] = segmentedBasedOnThresholds(img, segmentation_thresholds, structuring_element)

    if nargin < 3
        apply_bw_closing = false;
    else
        apply_bw_closing = true;
    end
    
    n_rgb_channels = size(img, 3);

    bw_channelwise = zeros(size(img));

    % binary image for each color channel
    for i = 1:n_rgb_channels
        bw_channelwise(:,:,i) = (img(:,:,i) > segmentation_thresholds(i).lower) & (img(:,:,i) < segmentation_thresholds(i).upper);  
        % apply closing to channel bw
        if apply_bw_closing == true
            bw_channelwise(:,:,i) = imclose(bw_channelwise(:,:,i), structuring_element);
        end
    end

   


    % overall binary image (bw_marker) is then given by the AND-Operation of all color
    % channels:
    bw_marker = ones(size(bw_channelwise,1), size(bw_channelwise,2), 1);
    for i = 1:n_rgb_channels
        bw_marker(:,:) = bw_marker(:,:) & bw_channelwise(:,:,i);    
    end

    % convert to int
    bw_marker = logical(bw_marker);
    bw_channelwise = logical(bw_channelwise);
end