function [overall_stats_export] = prepareOverallStatsForExport(overall_stats, CALIBFACTOR)
    free_area_clean_img_px = overall_stats.TotalFreeAreaCleanImage_px;
    free_area_material_img_px = overall_stats.TotalFreeAreaMaterialImage_px;
    covered_area_px = overall_stats.TotalCoveredArea_px;

    % Free area in clean image [px]
    overall_stats_export.TotalFreeAreaCleanImage_px = free_area_clean_img_px;
    
    % Free area in clean image [mm^2]
    overall_stats_export.TotalFreeAreaCleanImage_mm2 = free_area_clean_img_px .* CALIBFACTOR.^2;
    
    % Free area in material image [px]    
    overall_stats_export.TotalFreeAreaMaterialImage_px = free_area_material_img_px;
    
    % Free area in material image [mm^2]
    overall_stats_export.TotalFreeAreaMaterialImage_mm2 = free_area_material_img_px .* CALIBFACTOR.^2;
    
    % Covered area [px]
    overall_stats_export.TotalCoveredArea_px = covered_area_px;
    
    % Covered area [mm^2]
    overall_stats_export.TotalCoveredArea_mm2 = covered_area_px .* CALIBFACTOR;   
end

