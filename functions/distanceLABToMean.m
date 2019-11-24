function [distances] = distanceLABToMean(color_1, color_2)
% only use second and third color channel (a and b)
    distances = ((color_1(:,2) - color_2(:,2)).^2 + (color_1(:,3) - color_2(:,3)).^2).^0.5; % euceldian distance to a and b components      
end
