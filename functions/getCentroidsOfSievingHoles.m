function [centroids] = getCentroidsOfSievingHoles(img)
    bw = imbinarize(rgb2gray(img));    
    stats = regionprops(bw, 'Centroid');
    
    n_objects = length(stats);
    centroids = zeros(n_objects, 2);
    
    for i = 1:n_objects
        centroids(i,1) = stats(i).Centroid(1);
        centroids(i,2) = stats(i).Centroid(2);
    end
end

