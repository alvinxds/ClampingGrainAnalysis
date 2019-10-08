function [stats_clean,stats_material] = addNearestRegionToStats(stats_clean,stats_material)

    n_objects_material = length(stats_material);

    % centroids of objects in clean image
    centroids_clean = getCentroidsAsMatrix(stats_clean);
    centroids_material = getCentroidsAsMatrix(stats_material);
    
    % for all points in centroids_material find the nearest neighbor in the
    % pointcloud centroids_clean:
    
    [idx_nearest_neighbor, distance_to_nearest_neighbor] = dsearchn(centroids_clean, centroids_material);
    
    % store results in stats of the material image
    for i = 1:n_objects_material
        stats_material(i).NearestNeighborIndex = idx_nearest_neighbor(i);
        stats_material(i).DistanceToNearestNeighbor_px = distance_to_nearest_neighbor(i);
        
    end  
    

end

function [centroids] = getCentroidsAsMatrix(stats)
    n_objects = length(stats);
    n_dimensions = size(stats(1).Centroid,2);
    
    centroids = zeros(n_objects, n_dimensions);
        
    for i = 1:n_objects
        centroids(i,:) = stats(i).Centroid;        
    end

end