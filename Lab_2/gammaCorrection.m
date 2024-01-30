function outImage = gammaCorrection(image, gammaRGB)
    outImage = zeros(size(image));

    % Max value color is 1
    Dmax = 1;
    
    for channel = 1:3
        outImage(:,:,channel) = Dmax .* ((image(:,:,channel) ./ Dmax) .^ (1 / gammaRGB(channel)));
    end
end
