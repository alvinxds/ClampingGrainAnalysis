function [background_thresholds] = getBackgroundThresholds(img_clean_cropped,bw_clean, N_TIMES_STD)



    % get background pixels as [R G B] matrix
    n_rgb_channels = size(img_clean_cropped,3);
    
    img_clean_pixels = reshape(img_clean_cropped, [], n_rgb_channels, 1);
    bw_clean_pixels = reshape(bw_clean, [], 1);
    background_pixels = double(img_clean_pixels(bw_clean_pixels == 1, :));


% get color channel thresholds
    if nargin < 3
        N_TIMES_STD = 3;
    end

    % standard deviation of each color channel
    std_background = std(background_pixels,0,1);
    mean_background_color = mean(background_pixels,1);

    % Upper and lower thresholds
    for i = 1:n_rgb_channels % go trough all RGB channels
        % assuming a gaussian distribution of the marker colors, we calculate
        % the upper and lower thresholds by:

        % lower threshold
        background_thresholds(i).lower = mean_background_color(i) - N_TIMES_STD .* std_background(i);
        % make sure lower threshold is above zero
        background_thresholds(i).lower = max(background_thresholds(i).lower, 0);

        % upper threshold
        background_thresholds(i).upper = 255;%mean_background_color(i) + N_TIMES_STD .* std_background(i);
    end
    
end