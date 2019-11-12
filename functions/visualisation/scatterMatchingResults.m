function [] = scatterMatchingResults(stats_clean, stats_material)
    centroids_clean = getCentroidsAsMatrix(stats_clean);
    centroids_material = getCentroidsAsMatrix(stats_material);
    
    figure
%     scatter(centroids_clean(:,1), centroids_clean(:,2), 'blue');
%     hold on
%     scatter(centroids_material(:,1), centroids_material(:,2), 'red');
    
    
    % draw matched centroids
    matched_centroids_in_clean  = getMatchedCentroids(stats_clean, stats_material);
    
    
    hold on
    
    for i = 1:length(centroids_material)
        x_points = [centroids_material(i,1);matched_centroids_in_clean(i,1)];
        y_points = [centroids_material(i,2);matched_centroids_in_clean(i,2)];
        plot(x_points, y_points,'-x')
    end
    legend({'Material Centroids', 'Matched Clean Centroids'}, 'Location', 'best');
        
    
end

function [matched_centroids_in_clean] = getMatchedCentroids(stats_clean, stats_material)
    n_objects_material = length(stats_material);
    matched_centroids_in_clean = zeros(n_objects_material, 2);
    for i = 1:n_objects_material
        % corresponding index of matched centroid in clean image
        index = stats_material(i).NearestNeighborIndex;
        matched_centroids_in_clean(i,:) = stats_clean(index).Centroid;
    end
end