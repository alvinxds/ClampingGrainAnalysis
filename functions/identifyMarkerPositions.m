function [marker_positions] = identifyMarkerPositions(marker_stats)
    % the (rotated) image contains three markers. The three markers are
    % arranged in the same way as the markers of QR-Codes: one in the top
    % left corner, one in the bottom left and one in top right corner
    % this function identifies the three marker positions top left, bottom
    % left and top right from arbitrary rotated marker points
    
    % Vertex positions of a triangle formed by the three marker centroids
    v1 = marker_stats(1).Centroid';
    v2 = marker_stats(2).Centroid';
    v3 = marker_stats(3).Centroid';
    
    %% find top left corner
    % find the vertex that is on the opposite site of the
    % hypotenuse, this is the top left marker:
    
    % the hypotenuse is the longest of the three lines, distance of the
    % vertexes (lines) are given by
    d_12 = norm(v2 - v1);
    d_23 = norm(v3 - v2);
    d_31 = norm(v1 - v3);
    
    d_max = max([d_12, d_23, d_31]);
    
    switch d_max
        case d_12
            marker_positions.topleft = v3;
            topleft_index = 3;
        case d_23
            marker_positions.topleft = v1;
            topleft_index = 1;
        case d_31
            marker_positions.topleft = v2;
            topleft_index = 2;
        otherwise
            error('Error in switch d_max.')            
    end
    
    %% find bottom left and top right corner
    
    % choose(arbitrarly) one of the two remaining (non top left) points and
    % then rotate the points, such that the line connecting v_topleft and
    % the chosen point is parallel to the x axis
    % we call the point choosen point v_a and the third point v_b
    v_topleft = marker_positions.topleft;
    
    switch topleft_index
        case 1
            v_a = v2;
            v_b = v3;
        case 2
            v_a = v3;
            v_b = v1;
        case 3
            v_a = v_1;
            v_b = v_2;
        otherwise
            error('Error in switch marker_positions.topleft.index.') 
    end
    
    rotation_angle = getAngleToXAxis(v_topleft, v_a);
    
    % rotate points by rotation angle
    [~, ~, v_b_rotated] = rotateTriangleAroundTopLeftVertex(v_topleft, v_a, v_b, rotation_angle);
    
    % check if the third point (v_b) is below or above this line (in
    % x-direction)
    if v_b_rotated(1) < v_topleft(1)
        % v_b is below line
        marker_positions.topright = v_a;
        marker_positions.bottomleft = v_b;
    else
        marker_positions.topright = v_b;
        marker_positions.bottomleft = v_a;
    end
        
end


function [angle] = getAngleToXAxis(p1, p2)
    dx = p2(1) - p1(1);
    dy = p2(2) - p1(2);
    angle = atan(dx./dy);
end

function [p1_rotated, p2_rotated, p3_rotated] = rotateTriangleAroundTopLeftVertex(p1, p2, p3, rotation_angle)
    % make p1 the origin:
    p1_0 = p1 - p1;
    p2_0 = p2 - p1;
    p3_0 = p3 - p1;
    
    % rotate by angle around origin (index "_0" = origin)
    R = [cos(rotation_angle), -sin(rotation_angle);sin(rotation_angle), cos(rotation_angle)];
    
    p1_rotated_0 = p1_0; % is origin
    p2_rotated_0 = R * p2_0;
    p3_rotated_0 = R * p3_0;
    
    p1_rotated = p1_rotated_0 + p1;
    p2_rotated = p2_rotated_0 + p1;
    p3_rotated = p3_rotated_0 + p1;
end

