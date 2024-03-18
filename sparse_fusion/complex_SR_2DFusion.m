function F= complex_SR_2DFusion(A,B,D,level)
overlap = 7;L0 = 8;
% SR

patch_size = sqrt(size(D, 1));

%directionalize D
mask = dire_mask(patch_size);
[D_45,D_135] = dataset_dire(D,mask);
norm_D_45 = sqrt(sum(D_45.^2, 1)); 
D_45 = D_45./repmat(norm_D_45, size(D, 1), 1);   
norm_D_135 = sqrt(sum(D_135.^2, 1)); 
D_135 = D_135./repmat(norm_D_135, size(D, 1), 1);
G_45 = D_45' * D_45;
G_135 = D_135' * D_135;

[AH,BH] = local_contrast(A,B,level);

[h,w]=size(A);
F=zeros(h,w);
cntMat=zeros(h,w);
cntMatBH=zeros(h,w);cntMatBL=zeros(h,w);

gridx = 1:patch_size - overlap : w-patch_size+1;
gridy = 1:patch_size - overlap : h-patch_size+1;

for ii = 1:length(gridx)
    for jj = 1:length(gridy)
        %cnt = cnt+1;
        xx = gridx(ii);
        yy = gridy(jj);
        
        cntMat(yy:yy+patch_size-1, xx:xx+patch_size-1) = cntMat(yy:yy+patch_size-1, xx:xx+patch_size-1) + 1;
        
        patch1 = A(yy:yy+patch_size-1, xx:xx+patch_size-1);
        patch1H = AH(yy:yy+patch_size-1, xx:xx+patch_size-1);
        patch1_45 = real( ifft2( fft2(patch1H).*mask ) );        
        patch1_135 = 2*patch1H - patch1_45;
        
        patch2 = B(yy:yy+patch_size-1, xx:xx+patch_size-1);
        patch2H = BH(yy:yy+patch_size-1, xx:xx+patch_size-1);
        patch2_45 = real( ifft2( fft2(patch2H).*mask ) );        
        patch2_135 = 2*patch2H - patch2_45;
        
        w1_45 = omp(D_45,patch1_45(:),G_45,L0);
        w1_135 = omp(D_135,patch1_135(:),G_135,L0);
        w2_45 = omp(D_45,patch2_45(:),G_45,L0);
        w2_135 = omp(D_135,patch2_135(:),G_135,L0);
        
        A1 = sum(abs(w1_45)) + sum(abs(w1_135));
        A2 = sum(abs(w2_45)) + sum(abs(w2_135));
        
        if A1 < A2
            cntMatBH(yy:yy+patch_size-1, xx:xx+patch_size-1) = cntMatBH(yy:yy+patch_size-1, xx:xx+patch_size-1) + 1;
        end
        
        if sum( sum( (patch1-patch1H).^2 ) ) <sum( sum( (patch2-patch2H).^2 ) )
            cntMatBL(yy:yy+patch_size-1, xx:xx+patch_size-1) = cntMatBL(yy:yy+patch_size-1, xx:xx+patch_size-1) + 1;
        end
        
    end
    %cnt
end

rateBL = cntMatBL./cntMat;
rateAL = (1-rateBL).^2;
rateBL = rateBL.^2;
rateBL = rateBL./(rateAL+rateBL);
FL = (1 - rateBL).*(A-AH) + rateBL.*(B-BH);

rateBH = cntMatBH./cntMat;
rateAH = (1-rateBH).^2;
rateBH = rateBH.^2;
rateBH = rateBH./(rateAH+rateBH);
FH = (1 - rateBH).*AH + rateBH.*BH;

F = FH + FL;

end


%frequency mask
function flag = dire_mask(patch_size)
   tempx = rand(1,patch_size);
   tempy = rand(patch_size,1);
   Ftemp = fft2(kron(tempx,tempy));
   Ftempa = fft2(kron(hilbert(tempx),hilbert(tempy)));
   flag = round( abs(Ftempa)./abs(Ftemp) );
end

%directional dictionary
function [dataset_45,dataset_135] = dataset_dire(data,mask)
   [row ,col] = size(data);
   patchsize = sqrt(row);
   dataset_45 = data;
   dataset_135 = data;
   for i =1:col
       data2d = reshape(data(:,i), [patchsize,patchsize] );
       data2d_45 = real( ifft2( fft2(data2d).*mask ) );       
       data2d_135 = 2*data2d - data2d_45;
       dataset_45(:,i) = data2d_45(:);
       dataset_135(:,i) = data2d_135(:);
   end
end


%local contrast
function [AH,BH] = local_contrast(A,B,level)  
   yita = 0;
   [a,b,c,d]= swt2(A,level,'db1');AL = iswt2(a,yita*b,yita*c,yita*d,'db1');
   AH = A - AL;

   [a,b,c,d]= swt2(B,level,'db1');BL = iswt2(a,yita*b,yita*c,yita*d,'db1');
   BH = B - BL;
end
