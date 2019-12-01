function [control_points_preselected] = getPreselectedControlPoints(marker_stats_clean,img_clean)
    
    % get centroids of sieving holes in img_clean:
    bw_clean = imbinarize(rgb2gray(img_clean));
    stats_clean = regionprops(bw_clean, 'Centroid');
    centroids_clean = getCentroids(stats_clean);

    % get marker positions
    marker_points = getSortedMarkerPoints(marker_stats_clean);
    marker_top_left = marker_points(1,:);
    marker_top_right = marker_points(2,:);
    marker_bottom_left = marker_points(3,:);
    
    % make grid of sample points
    N_GRIDPOINTS = 3;
    
    x = linspace(marker_top_left(1), marker_top_right(1), N_GRIDPOINTS);
    y = linspace(marker_top_left(2), marker_bottom_left(2), N_GRIDPOINTS);
    
    % compose grid: leave markers out
    
    grid_points = [];    
    for i = 1:N_GRIDPOINTS % x
        for j = 1:N_GRIDPOINTS % y
            if (i == 1 && j == 1) || (i == N_GRIDPOINTS && j == 1) || (i == 1 && j == N_GRIDPOINTS) % skip grid points of markers
                % skip
                disp('skip')
            else
                grid_points = [grid_points; x(i) y(j)];   
            end
        end
    end

    % find nearest centroids to gridpoints    
    idx_nearest_neighbor = dsearchn(centroids_clean, grid_points);
    
    control_points_preselected = centroids_clean(idx_nearest_neighbor,:);
    
    % add markers
    
    control_points_preselected = [marker_points; control_points_preselected];
end

function [centroids] = getCentroids(stats)

    n_centroids = length(stats);

    centroids = zeros(n_centroids, 2);

    for i = 1:n_centroids
        centroids(i,1) = stats(i).Centroid(1);
        centroids(i,2) = stats(i).Centroid(2);
    end
end
