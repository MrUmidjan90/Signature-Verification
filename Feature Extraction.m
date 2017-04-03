%% Main Program
clc;
clear all;
close all;
warning off;

%% HOG & Features

for Index=1:20
name = sprintf('%d.jpg',Index); 
II{Index}=imread(name); 
Img=II{Index};
Img=imresize(Img,[250 650]);
[~,~,C]=size(Img);
if C>1
    I=rgb2gray(Img);
else
    I=Img;
end

% Gabor filter
M=15;
N=5;
a=(0.4 / 0.05)^(1/(M-1));
count=1;
[JT1]=gabor(M,N,a,count,I);
Val=max(max(JT1));
JT2=JT1./Val;
JT3=im2bw(JT2,.65);

% % Feature Extraction
theta = 0:180;
[R,xp] = radon(JT3,theta);

% FD Calculation
[~,Num]=size(theta);
for p=1:Num
    Katz(p)=Katz_FD(R(:,p));
end

% %features set
FeatK(Index,:)=Katz;
end

%% Processing
% group={'Test1';'Test2';'Test3';'Test4';'Test5';'Test6';...
%         'Test7';'Test8';'Test9';'Test10';'Test11';'Test12';};
group={'Person1';'Person1';'Person1';'Person1';'Person1';'Person1';'Person1';'Person1';'Person1';'Person1';...
        'Person2';'Person2';'Person2';'Person2';'Person2';'Person2';'Person2';'Person2';'Person2';'Person2'};
save('FeatK','FeatK');
save('group','group');