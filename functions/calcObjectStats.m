function [object_stats_export] = calcObjectStats(stats_clean, global_calibfactor_clean, global_calibfactor_material)
    n_objects = length(stats_clean);
    
    object_stats_export = struct('Index', cell(n_objects,1)); % prelocate for speed
    
    for i = 1:n_objects        
        % Index
        object_stats_export(i).Index = i;
        
        % Clean Area [px]        
        object_stats_export(i).CleanArea_px = stats_clean(i).Area;
        
        % Clean Area [mm^2]
        object_stats_export(i).CleanArea_mm2 = stats_clean(i).Area .* global_calibfactor_clean.^2;
        
        % covered_area_px = clean_area_px - free_area_materialimg_px;
        object_stats_export(i).FreeAreaMaterial_px = stats_clean(i).AreaMaterialImage;
        
        % covered_area_px = clean_area_px - free_area_materialimg_px;
        object_stats_export(i).FreeAreaMaterial_mm2 = stats_clean(i).AreaMaterialImage .* global_calibfactor_material.^2;
        
        % Covered Area [mm^2]
        object_stats_export(i).CoveredArea_mm2 = object_stats_export(i).CleanArea_mm2 - object_stats_export(i).FreeAreaMaterial_mm2;
        
        % Relative Coverage [-]
        object_stats_export(i).RelativeCoverage = object_stats_export(i).CoveredArea_mm2 ./ object_stats_export(i).CleanArea_mm2;        
    end    
end

