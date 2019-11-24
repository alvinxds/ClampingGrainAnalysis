function [object_stats_export] = calcObjectStats(stats_clean, global_calibfactor)
    n_objects = length(stats_clean);
    
    object_stats_export = struct('Index', cell(n_objects,1)); % prelocate for speed
    
    for i = 1:n_objects        
        % Index
        object_stats_export(i).Index = i;
        
        % Clean Area [px]        
        object_stats_export(i).CleanArea_px = stats_clean(i).Area;
        
        % Clean Area [mm^2]
        object_stats_export(i).CleanArea_mm2 = stats_clean(i).Area .* global_calibfactor.^2;
        
        % covered_area_px = clean_area_px - free_area_materialimg_px;
        object_stats_export(i).FreeAreaMaterial_px = stats_clean(i).AreaMaterialImage;
        
        % covered_area_px = clean_area_px - free_area_materialimg_px;
        object_stats_export(i).FreeAreaMaterial_mm2 = stats_clean(i).AreaMaterialImage .* global_calibfactor.^2;
        
        % Covered Area [mm^2]
        object_stats_export(i).CoveredArea_mm2 = object_stats_export(i).CleanArea_mm2 - object_stats_export(i).FreeAreaMaterial_mm2;
        
        
        % Relative Coverage [-]
        
        relative_coverage = object_stats_export(i).CoveredArea_mm2 ./ object_stats_export(i).CleanArea_mm2;    
        
        % correct relative coverage: should be between 0 and 1
        relative_coverage_corr = min(max(relative_coverage, 0),1);
        
        object_stats_export(i).RelativeCoverage = relative_coverage_corr;
    end    
end

