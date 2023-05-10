%To detect Eyes
clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
cd 'input1'
[file path] = uigetfile('*.bmp;*.jpg','Pick an Image File');
if file==0
    warndlg('User did not select any image');
else

I=imread(file);
end
cd ..

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;







EyeDetect = vision.CascadeObjectDetector('EyePairBig');

%Read the input Image


BB1=step(EyeDetect,I);



figure,imshow(I);
rectangle('Position',BB1,'LineWidth',4,'LineStyle','-','EdgeColor','b');
title('Eyes Detection');
Eyes=imcrop(I,BB1);
figure,imshow(Eyes);


detector = buildDetector();
[bbox bbimg faces bbfaces] = detectFaceParts(detector,I,2);
for i=1:size(bbfaces,1)
 figure(4);
 imshow(bbfaces{i});
 title('Detected face');
end
L_Eye =  bbox(:,5:8);
R_Eye =  bbox(:,9:12);
mouth= bbox(:,13:16);
MOUTH_1=imcrop(I,mouth);
figure(7);
imshow(MOUTH_1);
Left_Eye=imcrop(I,L_Eye);
figure(5);
imshow(Left_Eye);
Right_Eye=imcrop(I,R_Eye);
figure(6);
imshow(Right_Eye);