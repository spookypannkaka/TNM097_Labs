function coloredShape = colorshape(color, shape)
%COLORSHAPE Takes in a shape image and an rgb color to color the shape with
%the given color

% Convert the shape image to grayscale and threshold it to remove
% background parts
shape = rgb2gray(shape);
shapePixels = shape >= 128;

if size(shape, 3) == 1
    shape = repmat(shape, [1, 1, 3]);
end

% Apply the color to the shape pixels
for channel = 1:3
    channelData = shape(:,:,channel); % Extract one color channel
    channelData(shapePixels) = color(channel); % Apply the color
    shape(:,:,channel) = channelData; % Put the modified channel back
end

% Set the alpha value of the background pixels to 0 (transparent)
alpha(~shapePixels) = 0;

coloredShape = shape;

end

