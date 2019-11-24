function [] = scatterCentroids(stats_clean, stats_material)
    centroids_clean = getCentroidsAsMatrix(stats_clean);
    centroids_material = getCentroidsAsMatrix(stats_material);
    
    figure
    scatter(centroids_clean(:,1), centroids_clean(:,2), 'blue');
    hold on
    scatter(centroids_material(:,1), centroids_material(:,2), 'red');
    axis equal

    legend({'Clean Centroids', 'Material Centroids'}, 'Location', 'best');   
    xlabel('X-Position (Camera COS)')
    ylabel('Y-Position (Camera COS)')
    title('Matched Centroids of Clean and Material Image')
end
