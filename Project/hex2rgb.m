function rgb = hex2rgb(hex)
    hex = char(hex);
    hex = strtrim(hex);

    r = hex2dec(hex(1:2)) / 255;
    g = hex2dec(hex(3:4)) / 255;
    b = hex2dec(hex(5:6)) / 255;

    rgb = [r, g, b];
end

% rgbColors = cellfun(@hex2rgb, hexColors, 'UniformOutput', false); % Convert each hex color to RGB
% rgbColors = vertcat(rgbColors{:}); % Convert cell array to a numeric matrix
