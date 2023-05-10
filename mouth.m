clc;
clear all;
close all;
cd 'input'
[file path] = uigetfile('*.bmp;*.jpg','Pick an Image File');
if file==0
    warndlg('User did not select any image');
else

I=imread(file);
end
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);

BB=step(MouthDetect,I);


figure,
imshow(I); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;
