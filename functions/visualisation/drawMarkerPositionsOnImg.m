function [img_with_marker] = drawMarkerPositionsOnImg(img,marker_stats)
    % settings
    img_width = size(img, 2);
    resize_factor = 5184./img_width;
    MARKER_SIZE = round(15 .* resize_factor);
    FONT_SIZE = round(45 .* resize_factor);
    TEXT_OFFSET = round([0 10] .* resize_factor);
    
    % drawing
    img_with_marker = img;
    
    n_marker = length(marker_stats);
    
    for i = 1:n_marker
        img_with_marker = insertMarker(img_with_marker, marker_stats(i).Centroid, 'Size', MARKER_SIZE, 'Color', 'yellow'); 
        img_with_marker = insertShape(img_with_marker, 'Rectangle', marker_stats(i).BoundingBox, 'Color', 'green', 'Opacity', 0, 'LineWidth', 1);
        img_with_marker = insertText(img_with_marker, marker_stats(i).Centroid + TEXT_OFFSET, marker_stats(i).Label, 'FontSize', FONT_SIZE, 'AnchorPoint', 'CenterTop');
        % add convex hull
        ch_visualisation = transformConvexHullForVisualisation(marker_stats(i).ConvexHull);
        img_with_marker = insertShape(img_with_marker, 'Polygon', ch_visualisation, 'Color', 'yellow', 'Opacity', 0, 'LineWidth', 3);
    end
end

function [ch_visualisation] = transformConvexHullForVisualisation(convex_hull)

    % x- and y-coordinates
    ch_x = convex_hull(:,1);
    ch_y = convex_hull(:,2);
    
    n_points = length(convex_hull);
    
    ch_visualisation = zeros(1, 2*n_points); % prelocate for performance
    
    for i = 1:n_points
        % add x-coordinate
        ch_visualisation(1,(2*i-1)) = ch_x(i);
        % add y-coordinate
        ch_visualisation(1,(2*i)) = ch_y(i);
    end
    
end