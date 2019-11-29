function [overlay_image] = overlayMasks(bw_clean,bw_material)

    bw_free_material_img = bw_clean & ~bw_material;

% 
%     stats_clean_image = regionprops(bw_clean);
% 
%     median_area_sieving_hole = median([stats_clean_image.Area]);
% 
%     rel_area_threshold = 0.02;
% 
%     min_area = round(rel_area_threshold .* median_area_sieving_hole);
% 
%     bw_free_material_img_pre = imerode(bw_free_material_img, strel('disk', 2));
%     bw_free_material_img_pre = bwareaopen(bw_free_material_img_pre, min_area);
    bw_free_material_img_pre = bw_free_material_img;

    overlay_image = zeros(size(bw_clean));
    overlay_image(bw_clean==1) = 127;
    overlay_image(bw_free_material_img_pre==1) = 255;
    overlay_image = uint8(overlay_image);
end