function [ M1_1 ] = featre(inp )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
img=imresize(inp,[512 512]);
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

end

