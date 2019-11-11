function [marker_thresholds] = getMarkerThresholds(img_marker, N_TIMES_STD)

    if nargin < 2
        N_TIMES_STD = 3;
    end

    n_rgb_channels = size(img_marker,3);


    % reshape colors as [R G B] matrix of size(n_pixels,n_channels)
    colors_marker = double(reshape(img_marker,[],n_rgb_channels,1));

    % standard deviation of each color channel
    std_marker = std(colors_marker,0,1);
    mean_marker_color = mean(colors_marker,1);

    % Upper and lower thresholds
    for i = 1:n_rgb_channels % go trough all RGB channels
        % assuming a gaussian distribution of the marker colors, we calculate
        % the upper and lower thresholds by:

        % lower threshold
        marker_thresholds(i).lower = mean_marker_color(i) - N_TIMES_STD .* std_marker(i);
        % make sure lower threshold is above zero
        marker_thresholds(i).lower = max(marker_thresholds(i).lower, 0);

        % upper threshold
        marker_thresholds(i).upper = mean_marker_color(i) + N_TIMES_STD .* std_marker(i);
    end

end

