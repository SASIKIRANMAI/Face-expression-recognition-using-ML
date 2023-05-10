function varargout = final_face_exp(varargin)
% FINAL_FACE_EXP MATLAB code for final_face_exp.fig
%      FINAL_FACE_EXP, by itself, creates a new FINAL_FACE_EXP or raises the existing
%      singleton*.
%
%      H = FINAL_FACE_EXP returns the handle to a new FINAL_FACE_EXP or the handle to
%      the existing singleton*.
%
%      FINAL_FACE_EXP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_FACE_EXP.M with the given input arguments.
%
%      FINAL_FACE_EXP('Property','Value',...) creates a new FINAL_FACE_EXP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_face_exp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_face_exp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final_face_exp

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_face_exp_OpeningFcn, ...
                   'gui_OutputFcn',  @final_face_exp_OutputFcn, ...
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


% --- Executes just before final_face_exp is made visible.
function final_face_exp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_face_exp (see VARARGIN)

% Choose default command line output for final_face_exp
handles.output = hObject;
a = ones(256,256);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
axes(handles.axes3);
imshow(a);
axes(handles.axes4);
imshow(a);
set(handles.edit1,'string','');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final_face_exp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_face_exp_OutputFcn(hObject, eventdata, handles) 
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
cd 'input1'
[file path] = uigetfile('*.bmp;*.jpg','Pick an Image File');
if file==0
    warndlg('User did not select any image');
else

Input=imread(file);
end
cd ..
axes(handles.axes1)
imshow(Input);
title('Input Image');
handles.Input = Input;
helpdlg('Input Image Is Selected');
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Input = handles.Input;
Input1=imresize(Input,[512 512]);
[r c p]=size(Input);
disp 'r=';
disp (r);
disp 'c=';
disp (c);
if(p==3)
Input2 =rgb2gray(Input1);
else
    Input1=Input;
end

J = imnoise(Input2,'salt & pepper',0.05);
c = medfilt2(J,[3 3]);

axes(handles.axes2)
imshow(c);
title('Preprocessed Image');
handles.c = c;
handles.Input1 = Input1;
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c =handles.c;
Input1 = handles.Input1 ;
Facepart = vision.CascadeObjectDetector;
Face = step(Facepart,c);
face=imcrop(c,Face);
% Num= size(Face,1);
 


FDetect = vision.CascadeObjectDetector;
%Read the input image

% I=imread('14.jpg');

%Returns Bounding Box values based on number of objects
BB1 = step(FDetect,face);
% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%     rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
% end
% title('Face Detection');
% hold off;
%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);
BB2=step(NoseDetect,face);
% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%     rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
% end
% title('Nose Detection');
% hold off;
%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);

BB3=step(MouthDetect,face);

% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%  rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
% end
% title('Mouth Detection');
% hold off;

%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB4=step(EyeDetect,face);
% figure,imshow(I);
% rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
% title('Eyes Detection');

axes(handles.axes3);
imshow(face); hold on
for i = 1:size(BB1,1)
    rectangle('Position',BB1(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
for i = 1:size(BB2,1)
     rectangle('Position',BB2(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
 for i = 1:size(BB3,1)
 rectangle('Position',BB3(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
 end
% rectangle('Position',BB4,'LineWidth',4,'LineStyle','-','EdgeColor','r');
% title('Face Detection');
hold off;

handles.face = face;
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
face = handles.face ;
img1=imresize(face,[512 512]);
[LL LH HL HH]=dwt2(img1,'haar');

%second level decomposition
[LL1 LH1 HL1 HH1]=dwt2(LL,'haar');

%third level decomposition
[LL2 LH2 HL2 HH2]=dwt2(LL1,'haar');



 e1=0;
 e2=0;
 e3=0;
 e4=0;
 for i=1:64
    for j=1:64      
        e1=e1+LL2(i,j);
        e2=e2+LH2(i,j);
        e3=e3+HL2(i,j);
        e4=e4+HH2(i,j);
    end 
end 
 en(1)=(1/4096)*e1;
 en(2)=(1/4096)*e2;
 en(3)=(1/4096)*e3;
 en(4)=(1/4096)*e3;
 e5=0;
 e6=0;
 e7=0;
 for i=1:128
    for j=1:128      
        e5=e5+LH1(i,j);
        e6=e6+HL1(i,j);
        e7=e7+HH1(i,j);
    end 
end 
 en(5)=(1/16384)*e5;
 en(6)=(1/16384)*e6;
 en(7)=(1/16384)*e7;
 e8=0;
 e9=0;
 e10=0;
 for i=1:256
    for j=1:256      
        e8=e8+LH(i,j);
        e9=e9+HL(i,j);
        e10=e10+HH(i,j);
    end 
end 
 en(8)=(1/65536)*e8;
 en(9)=(1/65536)*e9;
 en(10)=(1/65536)*e10;
M=en(1);

I=imresize(face,[512 512]);
I=im2double(I);
m=1;
for i=1:16:512
    for j=1:16:512
        for x=0:15
            for y=0:15
            img(x+1,y+1)=I(i+x,j+y);
            end
        end
            k=0;
            for l=1:16
                img_expect{k+1}=img(:,l)*img(:,l)';
                k=k+1;
            end
            imgexp=zeros(16:16);
            for l=1:16
                imgexp=imgexp+(1/16)*img_expect{l};%expectation of E[xx']
            end
            img_mean=zeros(16,1);
            for l=1:16
                img_mean=img_mean+(1/16)*img(:,l);
            end
            img_mean_trans=img_mean*img_mean';
            img_covariance=imgexp - img_mean_trans;
            [v{m},d{m}]=eig(img_covariance);
            temp=v{m};
             m=m+1;
            for l=1:16
                v{m-1}(:,l)=temp(:,16-(l-1));
            end
             for l=1:16
           trans_img1(:,l)=v{m-1}*img(:,l);
             end
           for x=0:15
               for  y=0:15
                   transformed_img(i+x,j+y)=trans_img1(x+1,y+1);
               end
           end
mask=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1  
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1  
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      ];
  trans_img=trans_img1.*mask;
           for l=1:16
           inv_trans_img(:,l)=v{m-1}'*trans_img(:,l);
           end
            for x=0:15
               for  y=0:15
                  inv_transformed_img(i+x,j+y)=inv_trans_img(x+1,y+1);
               end
           end
  
           
        end
end
axes(handles.axes4);
imshow(transformed_img);
[eigen_vector]=eig(transformed_img);




handles.M = M;
helpdlg('Feature extracted');
guidata(hObject, handles);



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M = handles.M ;
load data_basenew1;
X = data_basenew1;
disp (X);
Tc = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 4 4 4 4 4 4];
T = ind2vec(Tc);
disp(T);
spread = 1;
net = newpnn(X,T,spread);
% view(net);
Y = net(X);
Yc = vec2ind(Y);
x = M;
disp(x);
y = net(x);
ac = vec2ind(y)
disp (ac);
if(ac==1)
   
    set(handles.edit1,'string','Angry');
elseif(ac==2)
    
    set(handles.edit1,'string','Happy');
    elseif(ac==3)
    
    set(handles.edit1,'string','Sad');
    elseif(ac==4)
    
    set(handles.edit1,'string','Surprise');

end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = ones(256,256);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
axes(handles.axes3);
imshow(a);
axes(handles.axes4);
imshow(a);
set(handles.edit1,'string','');



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
