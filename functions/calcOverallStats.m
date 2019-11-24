function [overall_stats] = calcOverallStats(object_stats)

    % Free area in clean image [mm^2]
    overall_stats.TotalFreeAreaCleanImage_mm2 = sum([object_stats.CleanArea_mm2]);
    
    % Free area in material image [mm^2]
    overall_stats.TotalFreeAreaMaterialImage_mm2 = sum([object_stats.FreeAreaMaterial_mm2]);
    
    % Covered area [mm^2]
    overall_stats.TotalCoveredArea_mm2 = sum([object_stats.CoveredArea_mm2]);
end

