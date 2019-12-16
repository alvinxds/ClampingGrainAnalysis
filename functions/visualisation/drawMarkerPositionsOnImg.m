function [img_with_marker] = drawMarkerPositionsOnImg(img,marker_stats)
    % settings
    img_width = size(img, 2);
    resize_factor = 5184./img_width;
    MARKER_SIZE = round(30 .* resize_factor);
    FONT_SIZE = round(45 .* resize_factor);
    TEXT_OFFSET = round([0 10] .* resize_factor);
    MARKER_LENGTH = round(10 .* resize_factor);
    LINE_WIDTH = 8;
    
    % drawing
    img_with_marker = img;
    
    n_marker = length(marker_stats);
    
    for i = 1:n_marker
        % draw bb with annotation
        img_with_marker = insertObjectAnnotation(img_with_marker,'rectangle',marker_stats(i).BoundingBox,marker_stats(i).Label, 'TextBoxOpacity',1,'FontSize',FONT_SIZE, 'LineWidth', LINE_WIDTH);
        % draw centroid
        centroid = marker_stats(i).Centroid;
        marker_line_vertical(1,1:2) = centroid - [0, MARKER_SIZE/2];
        marker_line_vertical(1,3:4) = centroid + [0, MARKER_SIZE/2];
        marker_line_horizontal(1,1:2) = centroid - [MARKER_SIZE/2, 0];
        marker_line_horizontal(1,3:4) = centroid + [MARKER_SIZE/2, 0];
        
        img_with_marker = insertShape(img_with_marker, 'Line', marker_line_vertical, 'Color', 'yellow', 'LineWidth', LINE_WIDTH);
        img_with_marker = insertShape(img_with_marker, 'Line', marker_line_horizontal, 'Color', 'yellow', 'LineWidth', LINE_WIDTH);


%         img_with_marker = insertMarker(img_with_marker, marker_stats(i).Centroid, 'Size', MARKER_SIZE, 'Color', 'yellow'); 
%         img_with_marker = insertShape(img_with_marker, 'Rectangle', marker_stats(i).BoundingBox, 'Color', 'yellow', 'Opacity', 0, 'LineWidth', 3);
%         img_with_marker = insertText(img_with_marker, marker_stats(i).Centroid + TEXT_OFFSET, marker_stats(i).Label, 'FontSize', FONT_SIZE, 'AnchorPoint', 'CenterTop');
        % add convex hull
%         ch_visualisation = transformConvexHullForVisualisation(marker_stats(i).ConvexHull);
%         img_with_marker = insertShape(img_with_marker, 'Polygon', ch_visualisation, 'Color', 'yellow', 'Opacity', 0, 'LineWidth', 3);
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