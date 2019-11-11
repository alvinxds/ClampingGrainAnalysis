function [img_rotated] = rotateImageBasedOnMarkerPositions(img, marker_stats)
    % get marker and corresponding marker bounding box positions
    marker_pos_top_left = getMarkerCentroid(marker_stats, 'top_left');
    marker_pos_top_right = getMarkerCentroid(marker_stats, 'top_right');
    marker_pos_bottom_left = getMarkerCentroid(marker_stats, 'bottom_left');
    
    % calculate angle between top left and top right marker and x-axis
    angle = getAngleToXAxis(marker_pos_top_left, marker_pos_top_right);
    
    % rotate the three points by this angle
    [marker_pos_top_left_rotated, marker_pos_top_right_rotated, marker_pos_bottom_left_rotated] = rotateTriangleAroundFirstVertex(marker_pos_top_left, marker_pos_top_right, marker_pos_bottom_left, angle);
    
    % check if bottom_left is above top_left, if yes rotate by 180°
    if marker_pos_top_left_rotated(2) > marker_pos_bottom_left_rotated(2) % > because of coordinate system of image ;-)
        angle = angle + pi;
    end
    
    % correct rotation angle is now found and image will be rotated by this
    % angle
    img_rotated = imrotate(img, angle.*(180/pi));
    
    
    
end

function single_marker_stats = getMarkerCentroid(marker_stats, label)
    for i = 1:3
       if strcmp(label, marker_stats(i).Label)
           single_marker_stats = marker_stats(i).Centroid';  
       end
   end
end