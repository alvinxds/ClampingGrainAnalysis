function [filename_xlsx] = getXLSXFilename(filename_material_img)
    filename_material_img_withoutending = removeFileEndingFromFilename(filename_material_img);
    filename_xlsx = ['stats_', filename_material_img_withoutending, '.xlsx'];
end

