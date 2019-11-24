function [stats_clean] = addRelativeCoverageToStats(stats_clean, global_calibfactor_clean, global_calibfactor_material)
    % calculate the relative coverage of the sieving holes based on the area of
    % the corresponding material regions

    n_objects = length(stats_clean);

    for i = 1:n_objects
        % transform to mm²
        stats_clean(i).Area_mm2 = stats_clean(i).Area .* global_calibfactor_clean.^2;
        stats_clean(i).AreaMaterialImage_mm2 = stats_clean(i).AreaMaterialImage .* global_calibfactor_clean.^2;
        
        % calculate covered area
        area_sievinghole = stats_clean(i).Area_mm2;
        area_covered = area_sievinghole - stats_clean(i).AreaMaterialImage_mm2;
        stats_clean(i).RelativeCoverage = area_covered./area_sievinghole;
    end
end

