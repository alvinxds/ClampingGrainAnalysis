function [points_moved] = movePointsToNearestNeighbor(points,fixed_points)
    % find nearest Neighbor for all points of points fixed_points
    idx_nearest_neighbor = dsearchn(fixed_points, points);
    points_moved = fixed_points(idx_nearest_neighbor,:);
end

