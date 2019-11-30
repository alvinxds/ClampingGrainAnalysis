function [object_stats_export] = calcObjectStats(object_stats, global_calibfactor)

    n_objects = length(object_stats);
    
    object_stats_export = struct('Index', cell(n_objects,1)); % prelocate for speed
    
    for i = 1:n_objects       
        area_px = object_stats(i).Area ;
        pixel_values = object_stats(i).PixelValues;
        area_clamping_grain_px = nnz (pixel_values == 255);
        
        % Index
        object_stats_export(i).Index = i;
        
        % Sieving Hole Area [mm^2]
        object_stats_export(i).SievingHoleArea_mm2 = area_px .* global_calibfactor.^2;
        
        % Clamping Grain Area [mm^2]
        object_stats_export(i).ClampingGrainArea_mm2 = area_clamping_grain_px .* global_calibfactor.^2;
        
        % Relative Coverage [-]
        object_stats_export(i).RelativeCoverage = object_stats_export(i).ClampingGrainArea_mm2 ./ object_stats_export(i).SievingHoleArea_mm2;    

    end    
end

