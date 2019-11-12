function [stats] = applyFitGeoTransformation(stats, tform)
    n_objects = length(stats);
    
    for i = 1:n_objects
        % get centroid position
       centroid = stats(i).Centroid; 
       centroid_x = centroid(1);
       centroid_y = centroid(2);
       
       % apply transformation
       [centroid_transformed_x, centroid_transformed_y] = transformPointsForward(tform, centroid_x, centroid_y);
       
       % save in stats
       stats(i).Centroid = [centroid_transformed_x, centroid_transformed_y];
    end
end

