function [rgbColors, labColors] = hexInRgbAndLab(fileName)
%HEX2LAB Summary of this function goes here
%   Detailed explanation goes here

    file = fileread(fileName);
    hexColors = strsplit(file, '\n');
    hexColors = hexColors(~cellfun('isempty',hexColors));
    rgbColors = cellfun(@(c) uint8(hex2rgb(c) * 255), hexColors, 'UniformOutput', false);

    labColors = cell(size(rgbColors));
    for i = 1:length(rgbColors)
        labColors{i} = rgb2lab(double(rgbColors{i}) / 255);
    end

end

