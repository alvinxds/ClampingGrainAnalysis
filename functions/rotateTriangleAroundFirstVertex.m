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