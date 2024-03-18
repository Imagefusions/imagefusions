function rgb = hsi2rgb(HSI) 
% 将图像从HSI空间转换到RGB空间 
% 输入参数为hsi图像，输出变量为rgb 

% 分别取出H、S、I分量 
H=HSI(:,:,1)*2*pi; 
S=HSI(:,:,2); 
I=HSI(:,:,3);

% 定义R、G、B三个矩阵大小 
R=zeros(size(H));%size(H)求矩阵H的行列数，返回2个向量，第一个是行数，第二是列数 
G=zeros(size(H)); 
B=zeros(size(H));

% H在[0,120°）区间 
sy=find((0<=H)&(H<2*pi/3)); 
B(sy)=I(sy).*(1-S(sy)); 
R(sy)=I(sy).*(1+S(sy).*cos(H(sy))./cos(pi/3-H(sy))); 
G(sy)=3*I(sy)-(R(sy)+B(sy));

% H在[120°,240°）区间 
sy=find((2*pi/3<=H)&(H<4*pi/3)); 
R(sy)=I(sy).*(1-S(sy)); 
G(sy)=I(sy).*(1+S(sy).*cos(H(sy)-2*pi/3)./cos(pi-H(sy))); 
B(sy)=3*I(sy)-(R(sy)+G(sy));

% H在[240°,360°）区间 
sy=find((4*pi/3<=H)&(H<2*pi)); 
G(sy)=I(sy).*(1-S(sy)); 
B(sy)=I(sy).*(1+S(sy).*cos(H(sy)-4*pi/3)./cos(5*pi/3-H(sy))); 
R(sy)=3*I(sy)-(G(sy)+B(sy));

%级联，获取RGB影像 
rgb=cat(3,R,G,B);
end