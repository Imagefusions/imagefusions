function ycbcr = imrgb2ycbcr(rgb)
rgb = double(rgb);
mtxRGBtoYCbCr = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
% mtxRGBtoYCbCr = [  0.299,    0.587,    0.114;
%                 -0.1687, -0.3313,  0.5;
%                  0.5,   -0.4187, -0.0813];
ycbcr = zeros(size(rgb));

for i=1:3
    ycbcr(:,:,i) = rgb(:,:,1) * mtxRGBtoYCbCr(i,1)...
                  + rgb(:,:,2) * mtxRGBtoYCbCr(i,2)...
                  + rgb(:,:,3) * mtxRGBtoYCbCr(i,3);
end

end