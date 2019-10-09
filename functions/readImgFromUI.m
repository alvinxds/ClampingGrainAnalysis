function [img, path, filename] = readImgFromUI(message)
    [file, path] = uigetfile('*.jpg', message);
    img = imread(fullfile(path, file));
end

