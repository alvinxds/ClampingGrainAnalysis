function [object_stats_export] = prepareObjectStatsForExport(stats_clean, CALIBFACTOR)
    n_objects = length(stats_clean);
    
    object_stats_export = struct('Index', cell(n_objects,1)); % prelocate for speed
    
    for i = 1:n_objects
        % get infos from stats_clean
        clean_area_px = stats_clean(i).Area;
        free_area_materialimg_px = stats_clean(i).AreaMaterialImage;
        covered_area_px = clean_area_px - free_area_materialimg_px;
        relative_coverage = stats_clean(i).RelativeCoverage;
        
        % Index
        object_stats_export(i).Index = i;
        
        % Clean Area [px]        
        object_stats_export(i).CleanArea_px = clean_area_px;
        
        % Clean Area [mm^2]
        object_stats_export(i).CleanArea_mm2 = clean_area_px .* CALIBFACTOR.^2;
        
        % Covered Area [px]
        object_stats_export(i).CoveredArea_px = covered_area_px;
        
        % Covered Area [mm^2]
        object_stats_export(i).CoveredArea_mm2 = covered_area_px .* CALIBFACTOR.^2;
        
        % Relative Coverage [-]
        object_stats_export(i).RelativeCoverage = relative_coverage;
        
    end
    
end

