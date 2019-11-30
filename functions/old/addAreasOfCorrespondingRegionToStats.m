function [stats_clean,stats_material] = addAreasOfCorrespondingRegionToStats(stats_clean,stats_material)
    % for all regions (sieving holes) in stats_clean: find the
    % corresponding regions (see nearest neighbor matching) in
    % stats_material and sum up there area [px]
    
    n_objects_clean = length(stats_clean);
    n_objects_material = length(stats_material);
    
    for idx_clean = 1:n_objects_clean
        % initialize area
        stats_clean(idx_clean).AreaMaterialImage = 0;
        
        for idx_material = 1:n_objects_material
            if stats_material(idx_material).NearestNeighborIndex == idx_clean
                % matching objects => add area
                stats_clean(idx_clean).AreaMaterialImage = stats_clean(idx_clean).AreaMaterialImage + stats_material(idx_material).Area;
            end            
        end        
    end    
end

