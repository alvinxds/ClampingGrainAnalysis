function [img, path, file] = readImgFromUI(message, starting_folder)
    if nargin < 2
        starting_folder = pwd;
    end
    [file, path] = uigetfile(fullfile(starting_folder, '*.jpg'), message);
    img = imread(fullfile(path, file));
end

