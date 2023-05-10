clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;
%Read the input image

I=imread('14.jpg');

%Returns Bounding Box values based on number of objects
BB1 = step(FDetect,I);
% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%     rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
% end
% title('Face Detection');
% hold off;
%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);
BB2=step(NoseDetect,I);
% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%     rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
% end
% title('Nose Detection');
% hold off;
%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);

BB3=step(MouthDetect,I);

% figure,
% imshow(I); hold on
% for i = 1:size(BB,1)
%  rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
% end
% title('Mouth Detection');
% hold off;

%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB4=step(EyeDetect,I);
% figure,imshow(I);
% rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
% title('Eyes Detection');

figure,
imshow(I); hold on
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