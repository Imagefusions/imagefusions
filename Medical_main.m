clear all;
close all;
clc;

addpath(genpath('sparse_fusion'));
load('Dictionary\D_100000_256_8.mat');

num_img=20;

level = 3;
%3 --> CT-MRI;
%4 --> MR-T1-MR-T2;
%5 --> COLOR:i.e. MR-T1-PET;MR-T2-SPECT

for kk=1:num_img
k=mod(kk,10);
h=floor(kk/10);

 name1=['test_images/CTMRI/' num2str(kk) '_CT.png'];
 name2=['test_images/CTMRI/' num2str(kk) '_MRI.png'];

% name1=['test_images/MRT1-MRT2/s0' num2str(kk) '_MRT1.tif'];
% name2=['test_images/MRT1-MRT2/s0' num2str(kk) '_MRT2.tif'];

% name1=['test_images/MRI-PET/MR-T1/' num2str(kk) '.png'];
% name2=['test_images/MRI-PET/PET/' num2str(kk) '.png'];

%name1=['test_images/MRI-SPECT/MR-T2/' num2str(kk) 'gray.png'];
%name2=['test_images/MRI-SPECT/SPECT/' num2str(kk) '.png'];


namef1=['Results/CT-MRI/g_' num2str(h) num2str(k) '_ComSR.tif'];


image_input1=imread(name1);
image_input2=imread(name2);
img1=double(image_input1);
img2=double(image_input2);

tic;
% Gray :CT-MRI & MRT1-MRT2
imgf = uint8( complex_SR_2DFusion(img1,img2,D,level) );

% Color: MRI-PET & MRI-SPECT
addpath(genpath('methods_color'));
%YCRCB
%img2_ycbcr = imrgb2ycbcr(img2);  
%img2y = img2_ycbcr(:,:,1);

%imgfy =  complex_SR_2DFusion(img1,img2y,D,5) ;

%imgf_ycbcr = img2_ycbcr;
%imgf_ycbcr(:,:,1) = imgfy;
%imgf = imycbcr2rgb(imgf_ycbcr);

toc;

image_fusion=uint8(imgf);
figure;imshow(image_fusion);
imwrite(image_fusion,namef1);
end
