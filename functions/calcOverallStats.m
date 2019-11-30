function [overall_stats] = calcOverallStats(object_stats, global_calibfactor)
    overall_stats.TotalSievingArea_mm2 = sum([object_stats.SievingHoleArea_mm2]);
    overall_stats.ClampingGrainArea_mm2 = sum([object_stats.ClampingGrainArea_mm2]);
    overall_stats.GlobalCalibFactor_mm_per_px = global_calibfactor;
end

