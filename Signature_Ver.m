function varargout = Signature_Ver(varargin)
% SIGNATURE_VER M-file for Signature_Ver.fig
%      SIGNATURE_VER, by itself, creates a new SIGNATURE_VER or raises the existing
%      singleton*.
%
%      H = SIGNATURE_VER returns the handle to a new SIGNATURE_VER or the handle to
%      the existing singleton*.
%
%      SIGNATURE_VER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNATURE_VER.M with the given input arguments.
%
%      SIGNATURE_VER('Property','Value',...) creates a new SIGNATURE_VER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Signature_Ver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Signature_Ver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Signature_Ver

% Last Modified by GUIDE v2.5 03-Apr-2017 11:55:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Signature_Ver_OpeningFcn, ...
                   'gui_OutputFcn',  @Signature_Ver_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Signature_Ver is made visible.
function Signature_Ver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Signature_Ver (see VARARGIN)
imshow( [255 255 255;255 255 255;255 255 255]);
% Choose default command line output for Signature_Ver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Signature_Ver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Signature_Ver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;

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

Val=[FeatK(:,1),FeatK(:,46),FeatK(:,91),FeatK(:,136),FeatK(:,181)];

%% Processing
% group={'Test1';'Test2';'Test3';'Test4';'Test5';'Test6';...
%         'Test7';'Test8';'Test9';'Test10';'Test11';'Test12';};
group={'Balasubramanian.T';'Balasubramanian.T';'Balasubramanian.T';...
    'Balasubramanian.T';'Balasubramanian.T';'Balasubramanian.T';...
    'Balasubramanian.T';'Balasubramanian.T';'Balasubramanian.T';'Balasubramanian.T';...
        'Savithri';'Savithri';'Savithri';'Savithri';'Savithri';'Savithri';...
        'Savithri';'Savithri';'Savithri';'Savithri'};
save('FeatK','FeatK');
save('group','group');
save('Val','Val');
set(handles.Display,'String','Feature Extraction Complete');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.jpg'},'File Selector');
Image = strcat(pathname, filename);
A=double(filename(1:2))-48;
if A(2)>=0
   Index=A(1)*10+A(2);
else
   Index=A(1);
end
imshow(Image);
save('Image','Image');
set(handles.Display,'String','Input Image');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Image;
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
save ('Katz','Katz');
wtest=[Katz(1,1),Katz(1,46),Katz(1,91),Katz(1,136),Katz(1,181)];
save ('wtest','wtest');
ValNP=[Katz(1,1),Katz(1,46),Katz(1,91),Katz(1,136),Katz(1,181)];
save ('ValNP','ValNP');
set(handles.Display,'String','Features of Input Image extracted');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load Val;
load ValNP;
load group;
[n,d] = knnsearch(Val,ValNP,'k',3);
Result=tabulate(group(n));
set(handles.Display,'String',Result(1));

% --- Executes on button press in pushbutton5.
% function pushbutton5_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton5 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% load group;
% load FeatK;
% wxtrain=[FeatK(:,1),FeatK(:,46),FeatK(:,91),FeatK(:,136),FeatK(:,181)];
% wSVMStruct = svmtrain(wxtrain,group,'kernel_function','polynomial','Polyorder',12,'showplot',true);
% save('wSVMStruct','wSVMStruct');
% set(handles.Display,'String','SVM Train Complete');


% --- Executes on button press in pushbutton6.
% function pushbutton6_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton6 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% load wtest;
% load wSVMStruct;
% wspecies_svm = svmclassify(wSVMStruct,wtest);
% set(handles.Display,'String',wspecies_svm);
