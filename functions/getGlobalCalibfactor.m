function [global_calibfactor] = getGlobalCalibfactor(marker_stats, MARKER_RADIUS_MM)
    % get boundingbox measurements = radii
    n_marker = length(marker_stats);
    for i = 1:n_marker
        radii_x(i,1) = marker_stats(i).BoundingBox(3);
        radii_y(i,1) = marker_stats(i).BoundingBox(4);
    end

    % combine x and y radii
    radii = [radii_x;radii_y];
    clear radii_x radii_y

    median_radius_px = median(radii);
    % calculate calibfactor
    global_calibfactor = MARKER_RADIUS_MM ./ median_radius_px; % [mm/px]
end

