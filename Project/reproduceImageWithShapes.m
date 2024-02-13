function outputImage = reproduceImageWithShapes(partitionSize, hexFile, shapeFile, imageFile)
%REPRODUCEIMAGEWITHSHAPES Summary of this function goes here
%   Detailed explanation goes here

% Read the hex file and get RGB and LAB colors
[rgbColors, labColors] = hexInRgbAndLab(hexFile);

% Read the shape file and get a base shape image with correct alpha
[shape, ~, alpha] = imread(shapeFile);
[shapeRows, shapeCols, ~] = size(shape);

% Read the image file
im = imread(imageFile);
[rows, cols, ~] = size(im);
%modifiedIm = 255 * ones(size(im), 'uint8');

% Set up the output image that will be filled in with shapes
numShapesHorizontally = ceil(cols / partitionSize);
numShapesVertically = ceil(rows / partitionSize);
newImRows = numShapesVertically * shapeRows;
newImCols = numShapesHorizontally * shapeCols;
outputImage = 255 * ones(newImRows, newImCols, 3, 'uint8');

% Initialize list of closest color indexes
closestColorIndexes = zeros(ceil(rows/partitionSize), ceil(cols/partitionSize));

for i = 1:partitionSize:rows
    for j = 1:partitionSize:cols
        % Define the current block's end row and column
        endRow = min(i + partitionSize - 1, rows);
        endCol = min(j + partitionSize - 1, cols);

        % Extract the current block
        currentBlock = im(i:endRow, j:endCol, :);

        % Calculate the mean color of the current block
        meanColor = mean(mean(double(currentBlock), 1), 2);

        % Convert mean color to CIELAB and
        % calculate distance between mean CIELAB and palette CIELAB ?
        % and fetch the closest color
        meanColorLab = rgb2lab(meanColor / 255);

        closestColorIndex = findClosestColor(meanColorLab, labColors);

        closestColorRgb = rgbColors{closestColorIndex};

        ci = ceil(i / partitionSize);
        cj = ceil(j / partitionSize);

        closestColorIndexes(ci, cj) = closestColorIndex;

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

        % Apply the mean color to the current block in the modified image
%         for k = 1:3 % For each color channel
%             modifiedIm(i:endRow, j:endCol, k) = closestColorRgb(k);
%         end
           
    end
end

end
