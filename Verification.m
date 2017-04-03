%% Main Performance
clc;
clear all;
close all;

load FeatK;
load group;
%% Identification Using KNN
Val=[FeatK(:,1),FeatK(:,46),FeatK(:,91),FeatK(:,136),FeatK(:,181)];
% figure,gscatter(Val(:,1),Val(:,2),group)
% set(legend,'location','best')

[filename pathname] = uigetfile({'*.jpg'},'File Selector');
Image = strcat(pathname, filename);
A=double(filename(1:2))-48;
if A(2)>=0
   Index=A(1)*10+A(2);
else
   Index=A(1);
end

%% Feat Exct for selected Image
Img=imread(Image);
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
Thresh=max(max(JT1));
JT2=JT1./Thresh;
JT3=im2bw(JT2,.65);

% % Feature Extraction
theta = 0:180;
[R,xp] = radon(JT3,theta);

% FD Calculation
[~,Num]=size(theta);
for p=1:Num
    Katz(p)=Katz_FD(R(:,p));
end


ValNP=[Katz(1,1),Katz(1,46),Katz(1,91),Katz(1,136),Katz(1,181)];

[n,d] = knnsearch(Val,ValNP,'k',3);

% tabulate(group(n))
Result=tabulate(group(n));
%% Training Phase
% features = [Mean,Var,Skewness,Kurtosis,Entropy,Energy];
load group;
wxtrain=[FeatK(:,1),FeatK(:,46),FeatK(:,91),FeatK(:,136),FeatK(:,181)];
wSVMStruct = svmtrain(wxtrain,group,'kernel_function','polynomial','Polyorder',12,'showplot',true);

%% Testing Phase
wtest=[Katz(1,1),Katz(1,46),Katz(1,91),Katz(1,136),Katz(1,181)];
%% SVM Classifier    
wspecies_svm = svmclassify(wSVMStruct,wtest);
%% Outputs
disp('Signature Belongs According to SVM');
disp(wspecies_svm);
disp('Signature Belongs According to KKN');
disp(Result(1));