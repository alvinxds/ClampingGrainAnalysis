function [overlay_image] = overlayMasks(bw_clean,bw_material)
    % SETTINGS
    BORDER_WIDTH = 4;
    THRESHOLD_AREA_SHARE_BORDER_PIXELS = 0.8;

    % preprocess bw_clean: remove small objects
    stats_clean = regionprops(bw_clean, 'Area');
    areas = [stats_clean.Area];
    median_area = median(areas);
    threshold_area = ceil(0.8 .* median_area);
    
    % remove small holes in clean image
    bw_clean_org = bw_clean;
    bw_clean = bwareaopen(bw_clean_org, threshold_area);
    
    bw_clamping_grain = bw_clean & ~bw_material;
       
    
    % get masks of the borders of sieving holes    
    bw_clean_erored = imerode(bw_clean,  strel('disk',BORDER_WIDTH));
    bw_borders = ~bw_clean_erored & bw_clean;
    
    % detect and remove "glitch"
    bw_glitch = bw_borders & bw_clamping_grain;
    bw_clamping_grain_without_glitch = bw_clamping_grain & ~bw_glitch;
    
    % advanced: calculate area share of glitch    
    db_sum = bw_clamping_grain + bw_glitch;
    bw_sum = db_sum > 0; % 1 = without glitch, 2 = with glitch
    
    stats_sum_image = regionprops(bw_sum, db_sum,{'PixelIdxList', 'PixelValues', 'Area'});
    n_objects = length(stats_sum_image);
    
    bw_clamping_grain_preprocessed = bw_clamping_grain;
    
    for i = 1:n_objects
       pixel_values = stats_sum_image(i).PixelValues;
       pixel_ids = stats_sum_image(i).PixelIdxList;
       n_pixels_borders = nnz(pixel_values == 2);
       n_pixels_not_borders = nnz(pixel_values == 1);
       n_pixel = n_pixels_borders + n_pixels_not_borders;
       
       area_share_border = n_pixels_borders./n_pixel;
       
       if area_share_border > THRESHOLD_AREA_SHARE_BORDER_PIXELS
           % remove objects whose area is mostly in the border area
           bw_clamping_grain_preprocessed(pixel_ids) = 0;
       end
    end
    
    overlay_image = zeros(size(bw_clean));
    overlay_image(bw_clean==1) = 127;
    overlay_image(bw_clamping_grain_preprocessed==1) = 255;  
    overlay_image = uint8(overlay_image);   
end