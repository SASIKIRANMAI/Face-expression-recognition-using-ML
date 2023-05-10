cd 'input1'
[file path] = uigetfile('*.bmp;*.jpg','Pick an Image File');
if file==0
    warndlg('User did not select any image');
else

Input=imread(file);
end
cd ..
b=imresize(Input,[512 512]);
[r c p]=size(Input);
save p;
    if p==3 
        b1=rgb2gray(Input);
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
img1=imresize(face,[512 512]);



I=im2double(img1);
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

[eigen_vector]=eig(transformed_img);

feature= eigen_vector ;
load data_base;
X = database';
X=real(X);
disp (X);
Tc = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 4 4 4 4 4 4];
T = ind2vec(Tc);
disp(T);
spread = 1;
net = newpnn(X,T,spread);
% view(net);
Y = net(X);
Yc = vec2ind(Y);
x = feature;
x=real(x);
disp(x);
y = net(x);
ac = vec2ind(y)
disp (ac);
if(ac==1)
   
    helpdlg('angry');
elseif(ac==2)
    
    helpdlg('Happy');
    elseif(ac==3)
    
    helpdlg(' sad');
    elseif(ac==4)
    
    helpdlg('surprise');
end
    