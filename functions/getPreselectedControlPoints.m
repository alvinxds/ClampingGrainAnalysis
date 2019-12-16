function [control_points_preselected] = getPreselectedControlPoints(marker_stats_clean,centroids, N_GRIDPOINTS)

    % get marker positions
    marker_points = getSortedMarkerPoints(marker_stats_clean);
    marker_top_left = marker_points(1,:);
    marker_top_right = marker_points(2,:);
    marker_bottom_left = marker_points(3,:);
    
    % make grid of sample points    
    x = linspace(marker_top_left(1), marker_top_right(1), N_GRIDPOINTS);
    y = linspace(marker_top_left(2), marker_bottom_left(2), N_GRIDPOINTS);
    
    % compose grid: leave markers out    
    grid_points = [];    
    for i = 1:N_GRIDPOINTS % x
        for j = 1:N_GRIDPOINTS % y
%             if (i == 1 && j == 1) || (i == N_GRIDPOINTS && j == 1) || (i == 1 && j == N_GRIDPOINTS) % skip grid points of markers
%             else
                grid_points = [grid_points; x(i) y(j)];   
%             end
        end
    end

    % move grid points to nearest neighbor
    size(grid_points)
    size(centroids)
    control_points_preselected = movePointsToNearestNeighbor(grid_points, centroids);
end
