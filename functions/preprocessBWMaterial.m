function [bw_material_preprocessed] = preprocessBWMaterial(bw_material,bw_clean)

    stats_clean = regionprops(bw_clean, 'Area');
    sievinghole_areas_clean_px = [stats_clean.Area];
    
    threshold_area_material_px = 1.5 .* median(sievinghole_areas_clean_px);


    % seperate bw image into two bw images

    % image with objects > threshold_area_material_px

    bw_material_large_objects = bwareafilt(bw_material, [threshold_area_material_px, inf]);
    bw_material_sieving_holes = bwareafilt(bw_material, [0, threshold_area_material_px]);
    % improve here with BB measurements

    % remove parts of bw_material_large_objects between sieving holes from
    % bw_clean
    bw_material_large_objects(bw_clean == 0) = 0;
    
    bw_material_preprocessed = bw_material_large_objects | bw_material_sieving_holes;
% 
%     figure
%     imshowpair(bw_material_large_objects_copy, bw_material_large_objects, 'montage');

end