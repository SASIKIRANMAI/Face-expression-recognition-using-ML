clc;
clear all;
close all;
 fmt = '.jpg';
for i_3 = 1 : 9
    j_3=num2str(i_3);
    c_3 = strcat(j_3,fmt);
    cd 'angry'
    d1_3=imread(c_3);
    cd ..
    M1_3= data(d1_3);
    data3(i_3)=M1_3(1);
end
save data3;
for i_4 = 1 : 11
    j_4=num2str(i_4);
    c_4 = strcat(j_4,fmt);
    cd 'happy'
    d1_4=imread(c_4);
    cd ..
    M1_4= data(d1_4);
    data4(i_4)=M1_4(1);
end
save data4;
for i_5 = 1 : 4
    j_5=num2str(i_5);
    c_5 = strcat(j_5,fmt);
    cd 'sad'
    d1_5=imread(c_5);
    cd ..
    M1_5= data(d1_5);
    data5(i_5)=M1_5(1);
end
save data5;
for i_6 = 1 : 6
    j_6=num2str(i_6);
    c_6 = strcat(j_6,fmt);
    cd 'surprise'
    d1_6=imread(c_6);
    cd ..
    M1_6= data(d1_6);
    data6(i_6)=M1_6(1);
end
save data6;



data_basenew1=horzcat(data3,data4,data5,data6);
save data_basenew1;
