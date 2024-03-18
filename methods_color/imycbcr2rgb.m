function rgb = imycbcr2rgb(ycbcr)
ycbcr = double(ycbcr);

% mtxRGBtoYCbCr = [  0.299,    0.587,    0.114;
%                 -0.1687, -0.3313,  0.5;
%                  0.5,   -0.4187, -0.0813];
             
% mtxYCbCrtoRGB = mtxRGBtoYCbCr^(-1); 
mtxYCbCrtoRGB = [1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703];
rgb = zeros(size(ycbcr));

for i=1:3
    rgb(:,:,i) = ycbcr(:,:,1) * mtxYCbCrtoRGB(i,1)...
                  + ycbcr(:,:,2) * mtxYCbCrtoRGB(i,2)...
                  + ycbcr(:,:,3) * mtxYCbCrtoRGB(i,3);
end

end