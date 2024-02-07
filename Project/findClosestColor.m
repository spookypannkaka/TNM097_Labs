function closestColorIndex = findClosestColor(targetLab, paletteLab)
% Finds the palette color index that is the closest to the inputted color in Lab.

    numColors = numel(paletteLab);
    distances = zeros(1, numColors);

    targetLab = squeeze(targetLab);

    for i = 1:numColors
        colorLab = paletteLab{i};
        % Calculate Euclidean distance
        distances(i) = sqrt(sum((colorLab' - targetLab).^2));
    end

    % Find the index of the smallest distance
    [~, closestColorIndex] = min(distances);
end
