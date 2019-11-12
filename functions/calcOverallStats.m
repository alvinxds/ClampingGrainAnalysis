function [overall_stats_export] = calcOverallStats(object_stats)
    % Free area in clean image [px]
    overall_stats.TotalFreeAreaCleanImage_px = sum([object_stats.CleanArea_px]);
    
    % Free area in clean image [mm^2]
    overall_stats.TotalFreeAreaCleanImage_mm2 = sum([object_stats.CleanArea_mm2]);
    
    % Free area in material image [mm^2]
    overall_stats.TotalFreeAreaMaterialImage_mm2 = sum([object_stats.FreeAreaMaterial_mm2]);
    
    % Free area in material image [px]  
    overall_stats.TotalFreeAreaCleanImage_px = sum([object_stats.CleanArea_px]);
    
    % Covered area [mm^2]
    overall_stats.TotalCoveredArea_mm2 = sum([object_stats.CoveredArea_mm2]);
end

