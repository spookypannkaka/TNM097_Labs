function deltaE = computeDeltaE(xyzref,xyzest)
%XYZ2CIELAB Summary of this function goes here
%   Detailed explanation goes here

[L,a,b] = xyz2lab(xyzref(1,:), xyzref(2,:), xyzref(3,:));
[L2,a2,b2] = xyz2lab(xyzest(1,:), xyzest(2,:), xyzest(3,:));

deltaE = sqrt((L - L2).^2 + (a - a2).^2 + (b - b2).^2);

end

