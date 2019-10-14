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
    
    %%%
    figure;
    hold on
    axis('equal')
    dy = 100;
    scatter(v_topleft(1), v_topleft(2),'b')
    text(v_topleft(1), v_topleft(2) + dy,'v_top_left', 'Interpreter', 'none')
    scatter(v_a(1), v_a(2),'b')
    text(v_a(1), v_a(2) + dy,'v_a', 'Interpreter', 'none')
    scatter(v_b(1), v_b(2),'b')
    text(v_b(1), v_b(2) + dy,'v_b', 'Interpreter', 'none')
    
    %%%
    
    rotation_angle = getAngleToXAxis(v_topleft, v_a);
    
    % rotate points by rotation angle
    [v_topleft_rotated, v_a_rotated, v_b_rotated] = rotateTriangleAroundTopLeftVertex(v_topleft, v_a, v_b, rotation_angle);
    v_topleft_rotated
    v_a_rotated
    v_b_rotated
    
    %%%
    scatter(v_topleft_rotated(1), v_topleft_rotated(2),'r')
    text(v_topleft_rotated(1), v_topleft_rotated(2) + dy,'v_top_left_rotated', 'Interpreter', 'none')
    scatter(v_a_rotated(1), v_a_rotated(2),'r')
    text(v_a_rotated(1), v_a_rotated(2) + dy,'v_a_rotated', 'Interpreter', 'none')
    scatter(v_b_rotated(1), v_b_rotated(2),'r')
    text(v_b_rotated(1), v_b_rotated(2) + dy,'v_b_rotated', 'Interpreter', 'none')
    axis('equal')
    %%%
    
    % check if the third point (v_b) is below or above this line (above/below = in
    % y-direction)
    if v_b_rotated(2) < v_topleft(2)
        fprintf('v_b is below line\n');
        topright_index = v_a_index;
        bottomleft_index = v_b_index;
    else
        fprintf('v_b is above line\n');
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
    
    % make sure that p1 is left to p2 => otherwise rotate by 180°
    if p2_rotated(1) < p1_rotated(1) 
        [p1_rotated, p2_rotated, p3_rotated] = rotateTriangleAroundTopLeftVertex(p1_rotated, p2_rotated, p3_rotated, pi);
    end
    
end

