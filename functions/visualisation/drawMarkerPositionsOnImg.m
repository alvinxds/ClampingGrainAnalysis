function [img_with_marker] = drawMarkerPositionsOnImg(img,marker_stats)
    % settings
    img_width = size(img, 2);
    resize_factor = 5184./img_width;
    
    MARKER_SIZE = 15 .* resize_factor;
    FONT_SIZE = 45 .* resize_factor;
    TEXT_OFFSET = [0 10] .* resize_factor;
    
    % drawing
    img_with_marker = img;
    
    n_marker = length(marker_stats);
    
    for i = 1:n_marker
        img_with_marker = insertMarker(img_with_marker, marker_stats(i).Centroid, 'Size', MARKER_SIZE, 'Color', 'black');
        img_with_marker = insertText(img_with_marker, marker_stats(i).Centroid + TEXT_OFFSET, marker_stats(i).Label, 'FontSize', FONT_SIZE, 'AnchorPoint', 'CenterTop'); 
        
    end
end

