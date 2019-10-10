function [stats_clean] = addRelativeCoverageToStats(stats_clean)
    % calculate the relative coverage of the sieving holes based on the area of
    % the corresponding material regions

    n_objects = length(stats_clean);

    for i = 1:n_objects
        area_sievinghole = stats_clean(i).Area;
        area_covered = area_sievinghole - stats_clean(i).AreaMaterialImage;
        stats_clean(i).RelativeCoverage = area_covered./area_sievinghole;
    end
end

