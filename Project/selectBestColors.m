function bestColors = selectBestColors(rgbColors, numColors)
    % Ensure numColors is 50 as desired
    %numColors = 50;

    % Convert cell array to an Nx3 numeric matrix
    colorsMatrix = cell2mat(rgbColors');

    % Perform k-means clustering on the numeric matrix
    [~, centroids] = kmeans(double(colorsMatrix), numColors, 'Replicates', 5);

    % The centroids are the "best" or most representative colors
    %centroids = uint8(centroids);

    %bestColors = mat2cell(centroids, ones(1, numColors), 3);
    bestColors = mat2cell(uint8(centroids), ones(numColors, 1), 3);
end
