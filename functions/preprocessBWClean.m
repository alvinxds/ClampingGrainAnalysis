function [bw_clean_preprocessed] = preprocessBWClean(bw_clean, MIN_SIEVING_HOLES_SIZE_mm2, global_calibfactor_clean)

    min_sieving_hole_size = round(MIN_SIEVING_HOLES_SIZE_mm2 ./ global_calibfactor_clean.^2);
    bw_clean_preprocessed = bwareaopen(bw_clean, min_sieving_hole_size);
end

