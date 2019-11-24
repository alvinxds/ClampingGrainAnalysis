function img_cropped = cropImageBasedOnMarkerPositions(img_rotated, marker_stats, MARKER_MARGIN_CROP)
    
    % get the Bounding Box Position of each marker
    bb_pos_top_left = getMarkerBB(marker_stats, 'top_left');
    bb_pos_top_right = getMarkerBB(marker_stats, 'top_right');
    bb_pos_bottom_left = getMarkerBB(marker_stats, 'bottom_left');
    % definition of bounding box coordinates from MATLAB: [x_min y_min x_width y_height]
    
    % to crop the image we need to find 4 positions:
    
    % 1) left cutting position => is given by the min x-values of the top-left and
    % bottom-left marker
    x_min_top_left = bb_pos_top_left(1);
    x_min_bottom_left = bb_pos_bottom_left(1);
    
    left_cutting_pos = min(x_min_top_left, x_min_bottom_left);
    
    % 2) right cutting position => is given by the max x-value of the
    % top-right marker
    x_min_top_right = bb_pos_top_right(1);
    x_width_top_right = bb_pos_top_right(3);
    x_max_top_right = x_min_top_right + x_width_top_right;
    
    right_cutting_pos = x_max_top_right;
    
    % 3) top cutting position => is given by the min y-value of the
    % top-left and top-right marker
    y_min_top_left = bb_pos_top_left(2);
    y_min_top_right = bb_pos_top_right(2);
    
    top_cutting_pos = min(y_min_top_left, y_min_top_right);
    
    % 4) bottom cutting position => is given vy the max y-value of the
    % bottom-left marker
    y_min_bottom_left = bb_pos_bottom_left(2);
    y_height_bottom_left = bb_pos_bottom_left(4);
    y_max_bottom_left = y_min_bottom_left + y_height_bottom_left;
    
    bottom_cutting_pos = y_max_bottom_left;
    
    % transform into MATLAB cutting format and add margin
    
    img_height = size(img_rotated, 1);
    img_width = size(img_rotated, 2);
    
    left_cutting_pos = max(left_cutting_pos - MARKER_MARGIN_CROP, 0); % use max(x, 0) to make sure that cutting positions are in the image
    top_cutting_pos = max(top_cutting_pos - MARKER_MARGIN_CROP, 0); % "
    cutting_width = min(right_cutting_pos - left_cutting_pos + MARKER_MARGIN_CROP, img_width - left_cutting_pos);% use max(x, width - left) to make sure that cutting positions are in the image
    cutting_height = min(bottom_cutting_pos - top_cutting_pos + MARKER_MARGIN_CROP, img_height - top_cutting_pos); % "
    
    img_cropped = imcrop(img_rotated, [left_cutting_pos, top_cutting_pos, cutting_width, cutting_height]);    
    
end

function single_marker_stats = getMarkerBB(marker_stats, label)
    for i = 1:3
       if strcmp(label, marker_stats(i).Label)
           single_marker_stats = marker_stats(i).BoundingBox;  
       end
   end
end