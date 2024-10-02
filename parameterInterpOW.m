function [parameterInterp] = parameterInterpOW(parameter, zr, waterColumnMat)

dim = size(parameter);
a = size(waterColumnMat);
sspAtPoint = reshape(parameter, [dim(1)*dim(2), size(parameter, 3)]);
temp_intrp = zeros(dim(1)*dim(2), a(3));

dim = size(zr);
depthsAtPoint = reshape(zr,dim(1)*dim(2),dim(3));

waterColumnMat = reshape(waterColumnMat,a(1)*a(2),a(3));
for k = 1:dim(1)*dim(2)
        F = griddedInterpolant((depthsAtPoint(k,:)),(sspAtPoint(k,:)),"pchip","linear");
        temp_intrp(k,:) = (F(-(waterColumnMat(k,:))));
end

parameterInterp = reshape(temp_intrp, [dim(1), dim(2), a(3)]);
end

