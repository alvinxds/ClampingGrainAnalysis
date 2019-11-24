function [bw_marker, bw_channelwise] = segmentedBasedOnThresholdsHSV(img, segmentation_threshold)
    
    n_rgb_channels = size(img, 3);

    bw_channelwise = zeros(size(img));

    % binary image for each color channel
    for i = 1:n_rgb_channels
        bw_channelwise(:,:,i) = (img(:,:,i) > segmentation_threshold(i).lower) & (img(:,:,i) < segmentation_threshold(i).upper);  
        % apply closing to channel bw
    end

   


    % overall binary image (bw_marker) is then given by the AND-Operation of all color
    % channels:
    bw_marker = ones(size(bw_channelwise,1), size(bw_channelwise,2), 1);
    
    selected_channels = [1,3];
    for i = selected_channels
        bw_marker(:,:) = bw_marker(:,:) & bw_channelwise(:,:,i);    
    end

    % convert to int
    bw_marker = logical(bw_marker);
    bw_channelwise = logical(bw_channelwise);
    
    % remove small objects
    bw_marker = bwareaopen(bw_marker, 2);
    
    % opening
    bw_marker = imopen(bw_marker, strel('sphere',2));
end