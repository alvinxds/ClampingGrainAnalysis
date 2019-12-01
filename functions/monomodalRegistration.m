function [img_clean_gray, img_material_gray_reg] = monomodalRegistration(img_clean,img_material)

    % convert to greyscale images
    img_clean_gray = rgb2gray(img_clean);
    img_material_gray = rgb2gray(img_material);
    
    % initialize optimizer 
    [optimizer, metric] = imregconfig('monomodal');
    
    optimizer.MaximumIterations = 20; % for testing
    optimizer.MaximumStepLength = 0.1 .* 0.0625;
    % registration
    img_material_gray_reg = imregister(img_material_gray, img_clean_gray, 'similarity', optimizer, metric);
    figure
    imshowpair(img_clean_gray, img_material_gray_reg, 'falsecolor')
end

