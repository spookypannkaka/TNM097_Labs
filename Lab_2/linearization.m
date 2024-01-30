function outImage = linearization(image, x, y)
    outImage = zeros(size(image));

    for channel = 1:3
        linearizedChannel = interp1(y(:,:,channel), x, image(:,:,channel), 'pchip');
        
        outImage(:,:,channel) = linearizedChannel;
    end

end

