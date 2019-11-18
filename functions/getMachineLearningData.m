% function [foreground_pixels] = getMachineLearningData(img_clean_cropped,bw_clean)

    % get machine learnign data
    X = double(reshape(img_clean_cropped, [], 3, 1));
    y = double(reshape(bw_clean, [], 1));
    
    % train modell
    classifier = fitcsvm(X, y);
    
% %     predict image
% %     img_reshaped = double(reshape(img_material_cropped_warped, [], 3, 1));
% %     bw_predicted = predict(classifier, img_reshaped);
% %     bw_predicted = reshape(bw_predicted, size(bw_clean));
% %     
% %     figure
% %     imshowpair(bw_material, logical(bw_predicted))
    
    
    % add classes: 0 for background 

% end

