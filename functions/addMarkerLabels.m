function [marker_stats] = addMarkerLabels(marker_stats, img_height)
    % the (rotated) image contains three markers. The three markers are
    % arranged in the same way as the markers of QR-Codes: one in the top
    % left corner, one in the bottom left and one in top right corner
    % this function identifies the three marker positions top left, bottom
    % left and top right from arbitrary rotated marker points
    
    % Vertex positions of a triangle formed by the three marker centroids
    centroids = getMarkerCentroidsAsMatrix(marker_stats);
    % switch from img coordinate system (COS) to standard xy COS
    centroids_xy = transformToXYCOS(centroids, img_height);
    
    %% find top left corner
    % find the vertex that is on the opposite site of the
    % hypotenuse, this is the top left marker:
    
    % the hypotenuse is the longest of the three lines, distance of the
    % vertexes (lines) are given by
    d_12 = norm(centroids_xy(:,2) - centroids_xy(:,1));
    d_23 = norm(centroids_xy(:,3) - centroids_xy(:,2));
    d_31 = norm(centroids_xy(:,1) - centroids_xy(:,3));
    
    d_max = max([d_12, d_23, d_31]);
    
    switch d_max
        case d_12
            topleft_index = 3;   
        case d_23
            topleft_index = 1;
        case d_31
            topleft_index = 2;
        otherwise
            error('Error in switch d_max.')            
    end
    
    v_topleft = centroids_xy(:,topleft_index);
    
    %% find bottom left and top right corner
    
    % choose(arbitrarly) one of the two remaining (non top left) points and
    % then rotate the points, such that the line connecting v_topleft and
    % the chosen point is parallel to the x axis
    % we call the point chosen point v_a and the third point v_b
        
    switch topleft_index
        case 1
            v_a_index = 2;
            v_b_index = 3;
        case 2
            v_a_index = 3;
            v_b_index = 1;
        case 3
            v_a_index = 1;
            v_b_index = 2;
        otherwise
            error('Error in switch marker_positions.topleft.index.') 
    end
    
    v_a = centroids_xy(:, v_a_index);
    v_b = centroids_xy(:, v_b_index);
    
    rotation_angle = getAngleToXAxis(v_topleft, v_a);
    
    % rotate points by rotation angle
    [~ ,v_a_rotated, v_b_rotated] = rotateTriangleAroundFirstVertex(v_topleft, v_a, v_b, rotation_angle);
    
    % make sure that v_a_rotated is right to v_topleft_rotated (in
    % x-direction)
    if (v_a_rotated(1) < v_topleft(1))
        % v_a_rotated is left to v_topleft_rotated => rotate by 180° = pi
        [~ ,v_a_rotated, v_b_rotated] = rotateTriangleAroundFirstVertex(v_topleft, v_a_rotated, v_b_rotated, pi);
    end
    
    % check if the third point (v_b) is below or above this line (above/below = in
    % y-direction)
    if v_b_rotated(2) < v_topleft(2)
        topright_index = v_a_index;
        bottomleft_index = v_b_index;
    else
        topright_index = v_b_index;
        bottomleft_index = v_a_index;
    end
    
    marker_stats(topleft_index).Label = "top_left";
    marker_stats(topright_index).Label = "top_right";
    marker_stats(bottomleft_index).Label = "bottom_left";
        
end


function [centroids_xy] = transformToXYCOS(centroids, img_height)
    n_marker = length(centroids);
    centroids_xy = zeros(2,n_marker);
    
    for i = 1:n_marker
        % x-orientation remains the same
        centroids_xy(1, i) = centroids(1,i);
        % y-axis is inverted
        centroids_xy(2,i) = img_height - centroids(2,i);
    end
end

function [centroids] = getMarkerCentroidsAsMatrix(marker_stats)
    n_marker = length(marker_stats);
    centroids = zeros(2,n_marker);
    for i = 1:n_marker
       centroids(:,i) = marker_stats(i).Centroid'; 
    end
end

function [angle] = getAngleToXAxis(p1, p2)
    dx = p2(1) - p1(1);
    dy = p2(2) - p1(2);
    angle = atan(dy./dx);
end

function [v1_rotated, v2_rotated, v3_rotated] = rotateTriangleAroundFirstVertex(v1, v2, v3, rotation_angle)
    center = v1;
    
    % passive rotation matrix
    R = [cos(rotation_angle), sin(rotation_angle); -sin(rotation_angle), cos(rotation_angle)];
    
    % shift to center
    v1_shifted = v1 - center;
    v2_shifted = v2 - center;
    v3_shifted = v3 - center;
    
    % rotate around center
    v1_shifted_rotated = R*v1_shifted;
    v2_shifted_rotated = R*v2_shifted;
    v3_shifted_rotated = R*v3_shifted;
    
    % shift back again
    v1_rotated = v1_shifted_rotated + center;
    v2_rotated = v2_shifted_rotated + center;
    v3_rotated = v3_shifted_rotated + center;
end

