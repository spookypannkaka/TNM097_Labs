function deltaE = computeDeltaE(xyzref,xyzest)

if (size(xyzref, 1)) == 2
    [L,a,b] = xyz2lab(xyzref(1,:), xyzref(2,:), xyzref(3,:));
    [L2,a2,b2] = xyz2lab(xyzest(1,:), xyzest(2,:), xyzest(3,:));

    deltaE = sqrt((L - L2).^2 + (a - a2).^2 + (b - b2).^2);
else
    labref = xyz2lab(xyzref);
    labest = xyz2lab(xyzest);
    
    deltaE = sqrt((labref(:,:,1) - labest(:,:,1)).^2 + (labref(:,:,2) - labest(:,:,2)).^2 + (labref(:,:,3) - labest(:,:,3)).^2);
end

