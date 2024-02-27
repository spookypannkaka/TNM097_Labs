function outputImage = reproduceImageWithShapes(partitionSize, shapeFile, imageFile, hexFile, mode)

% Read the shape file and get a base shape image with correct alpha
[shape, ~, alpha] = imread(shapeFile);
[shapeRows, shapeCols, ~] = size(shape);

% Read the image file
im = imread(imageFile);

% Determine the larger dimension
largerDimension = max(size(im, 1), size(im, 2));
threshold = 600;

% Check if the larger dimension is greater than treshold
if largerDimension > threshold
    % Calculate the scaling factor
    scaleFactor = threshold / largerDimension;

    % Calculate the new dimensions
    targetHeight = size(im, 1) * scaleFactor;
    targetWidth = size(im, 2) * scaleFactor;

    % Resize the image
    im = imresize(im, [targetHeight, targetWidth], 'bicubic');
    
    disp('Image has been resized. Resizing may result in loss of detail and image quality degradation.');
end

[rows, cols, ~] = size(im);

[rgbColors, labColors] = hexInRgbAndLab(hexFile);
newRgbColors = [];

if strcmp(mode, 'meanColorDistance')
    % Skip
elseif strcmp(mode, 'globalReduction')
    rgbColors = selectBestColors(rgbColors, 50);
    labColors = cell(size(rgbColors));
    for i = 1:length(rgbColors)
        labColors{i} = rgb2lab(double(rgbColors{i}) / 255);
    end
elseif strcmp(mode, 'imageColorDistance')
    % Generate palette from the input image using k-means clustering
    imFlat = reshape(im, [], 3);
    [~, centroids] = kmeans(double(imFlat), 100, 'MaxIter', 1000, 'Replicates', 3);

    rgbColorsImage = mat2cell(uint8(centroids), ones(1, size(centroids, 1)), 3);

    labColorsImage = cell(size(rgbColorsImage));
    for i = 1:length(rgbColorsImage)
        labColorsImage{i} = rgb2lab(double(rgbColorsImage{i}) / 255);
        currentLabColor = reshape(labColorsImage{i}, 1, 1, 3);
        closestColorIndex = findClosestColor(currentLabColor, labColors);
        closestColorRgb = rgbColors{closestColorIndex};
        newRgbColors{i} = closestColorRgb;
    end

    rgbColors = newRgbColors;
    labColors = cell(size(rgbColors));
    for i = 1:length(rgbColors)
        labColors{i} = rgb2lab(double(rgbColors{i}) / 255);
    end
else
    disp("Selected mean color distance as input was wrong");
end

% Set up the output image that will be filled in with shapes
numShapesHorizontally = ceil(cols / partitionSize);
numShapesVertically = ceil(rows / partitionSize);
newImRows = numShapesVertically * shapeRows;
newImCols = numShapesHorizontally * shapeCols;
outputImage = 255 * ones(newImRows, newImCols, 3, 'uint8');

for i = 1:partitionSize:rows
    for j = 1:partitionSize:cols
        % Define the current block's end row and column
        endRow = min(i + partitionSize - 1, rows);
        endCol = min(j + partitionSize - 1, cols);

        % Extract the current block
        currentBlock = im(i:endRow, j:endCol, :);

        % Calculate the mean color of the current block
        meanColor = mean(mean(double(currentBlock), 1), 2);

        % Add 21.5% white to the mean color
        whitePercentage = 21.5 / 100;
        white = [1, 1, 1];
        meanColorWithWhite = mean(meanColor * (1 - whitePercentage) + white * whitePercentage);

        % Convert mean color with added white to CIELAB
        meanColorLab = rgb2lab(meanColorWithWhite / 255);

        % Calculate distance between mean CIELAB and palette CIELAB
        % and fetch the closest color
        closestColorIndex = findClosestColor(meanColorLab, labColors);


        closestColorRgb = rgbColors{closestColorIndex};

        ci = ceil(i / partitionSize);
        cj = ceil(j / partitionSize);

        coloredCircle = colorshape(closestColorRgb, shape);

        % Set alpha channel based on the "base" circle
        alphaChannel = alpha;

        circleTop = (ci - 1) * shapeRows + 1;
        circleLeft = (cj - 1) * shapeCols + 1;

        for k = 1:3  % For each color channel
            % Extract the current background where the circle will be placed
            currentBackground = outputImage(circleTop:(circleTop + shapeRows - 1), circleLeft:(circleLeft + shapeCols - 1), k);

            % Blend the coloredCircle onto the currentBackground using the alpha channel
            outputImage(circleTop:(circleTop + shapeRows - 1), circleLeft:(circleLeft + shapeCols - 1), k) = ...
                uint8(double(coloredCircle(:, :, k)) .* double(alphaChannel) / 255 + ...
                double(currentBackground) .* (1 - double(alphaChannel) / 255));
        end  
    end
end
end

