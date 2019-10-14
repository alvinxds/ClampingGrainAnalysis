function [counting_stats] = getCountingStats(stats_clean, COVERAGE_CLASS_EDGES)
    relative_coverage = [stats_clean.RelativeCoverage]';
    counted_holes = histcounts(relative_coverage, COVERAGE_CLASS_EDGES);
    
    n_edges = length(COVERAGE_CLASS_EDGES);
    
    for i = 1:(n_edges-1)
        counting_stats(i).LowerClassBoundary = COVERAGE_CLASS_EDGES(i);
        counting_stats(i).UpperClassBoundary = COVERAGE_CLASS_EDGES(i+1);
        counting_stats(i).NumberOfSieveOpenings = counted_holes(i);  
        
        % we use eps as an edge to count all holes with a coverage factor
        % of zero (are between 0 and eps); for better visualisation in the
        % excel sheet we replace the value of eps by 0
        if counting_stats(i).LowerClassBoundary == eps
           counting_stats(i).LowerClassBoundary = 0;
        end
        
        if counting_stats(i).UpperClassBoundary == eps
            counting_stats(i).UpperClassBoundary = 0;
        end
    end
    
end

