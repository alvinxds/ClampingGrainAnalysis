function [centroids] = getCentroidsAsMatrix(stats)
    n_objects = length(stats);
    n_dimensions = size(stats(1).Centroid,2);
    
    centroids = zeros(n_objects, n_dimensions);
        
    for i = 1:n_objects
        centroids(i,:) = stats(i).Centroid;        
    end

end