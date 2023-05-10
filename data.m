function [ feature ] = data( d1_1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
a = d1_1;
b=imresize(a,[512 512]);
[r c p]=size(a);
save p;
    if p==3 
        b1=rgb2gray(a);
    else
        b1=a;
    end
    
    
     J = imnoise(b1,'salt & pepper',0.05);
     c = medfilt2(J,[3 3]);
     FDetect = vision.CascadeObjectDetector;
     BB = step(FDetect,c);
     face=imcrop(c,BB);
     
     
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

figure(1);
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
     
     
     
     
     
%      detector = buildDetector();
%     [bbox bbimg faces bbfaces] = detectFaceParts(detector,b,2);
%      L_Eye =  bbox(:,5:8);
%     R_Eye =  bbox(:,9:12);
%     mouth= bbox(:,13:16);
%     MOUTH_1=imcrop(b,mouth);
%     Left_Eye=imcrop(b,L_Eye);
%     Right_Eye=imcrop(b,R_Eye);

%     f_1=featre(MOUTH_1);
%     f_2=featre(Left_Eye);
%     f_3=featre(Right_Eye);
%     feature= horzcat(f_1,f_2,f_3);
img=imresize(face,[512 512]);
[LL LH HL HH]=dwt2(img,'haar');

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
M1_1=en(1);
feature= M1_1;
    
    
   


 
 
 

end

