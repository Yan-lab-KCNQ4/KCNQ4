% This file is used to read and save the whole-cell current amplitude at +40 mV when single-expressed.
% File name format: 
% If the first amino acide "M" was mutated to "F" and this is the second cell you recorded,
% and the capacitance is 10,
% then the file name should be "001MF_C02F10P1_20220101".


clear all
clc
prompt = 'Please copy and paste the file path';
str = input(prompt,'s');
Source_Pathname=[str,'\*.abf']
Allfilename=dir(Source_Pathname);
% Please copy and paste the path of this .m file

DST_Pathname='D:\calculate\electric current';
filenamelength=length(Allfilename);

% Arrange documents
for i=1:filenamelength
    copyfile([str,'\',Allfilename(i).name],DST_Pathname);
end
filenameP1={};
filenameP2={};
j=1;
k=1;
for i=1:filenamelength
    filename= Allfilename(i).name;
    filenameafter=extractAfter(filename,12);
    filenamenamebefore=extractBefore(filenameafter,3);
    if filenamenamebefore=='P1'
        filenameP1{j}=[Allfilename(i).name];
        j=j+1;
    else
         filenameP2{k}=[Allfilename(i).name];
         k=k+1;
    end
end
filenameP1_Length=length(filenameP1);
filenameP2_Length=length(filenameP2);
dataP1={};
dataP2={};
capacitanceP1=[];
capacitanceP2=[];
for i=1:filenameP1_Length
    open_filename=filenameP1{i};
    dataP1{i}=abfload(open_filename,'start',100,'sweep','a');
    filenameafter=extractAfter(open_filename,10);
    filenamenamebefore=extractBefore(filenameafter,3);
    capacitanceP1(i)=str2num(filenamenamebefore);
end
for i=1:filenameP2_Length
    open_filename=filenameP2{i};
    dataP2{i}=abfload(open_filename,'start',100,'sweep','a');
    filenameafter=extractAfter(open_filename,10);
    filenamenamebefore=extractBefore(filenameafter,3);
    capacitanceP2(i)=str2num(filenamenamebefore);
end
Para_dataP1=size(dataP1{1});
I={};
I_C_ratio={};

% Extraction of data
for i=1:filenameP1_Length
    j=1:8;
    I{i}(j)=mean(dataP1{i}(11014:11264,2,j));
    I_C_ratio{i}(j)=mean(dataP1{i}(11014:11264,2,j))/capacitanceP1(i);
end
CellType={};
for i=1:filenameP1_Length
    CellType_after=extractAfter(filenameP1{i},3);
    CellType_before=extractBefore(CellType_after,3);
    CELL = extractAfter(CellType_before,1);
    BEFORE = extractBefore(CellType_before,2);
    NUM = extractBefore(filenameP1{i},4);
    CellType{i}= CellType_before;
    NAME = [BEFORE,NUM,CELL];
    CellTYPE{i} = NAME; %
end

% Extraction of final results
CellType_num=[];
kk=1;
judge_Type=CellType{1};
judge_Type_1=[];
for i=1:filenameP1_Length
    if CellType{i}==judge_Type
        CellType_num(i)=kk;
    else
        kk=kk+1;
        CellType_num(i)=kk;
        judge_Type=CellType{i};
    end
end
[type_num,loc]=unique(CellType_num);
num_cell=numel(type_num);
num_each_cell={};
for i=1:num_cell
    num_each_cell{i}=length(find(CellType_num==i));
end
I_Data=zeros(8,filenameP1_Length);
I_C_Data=zeros(8,filenameP1_Length);
for i=1:filenameP1_Length
     I_Data(:,i)=flipud(I{1,i}');
    I_C_Data(:,i)=flipud(I_C_ratio{1,i}');
end
%I_C_Data_final=zeros(8,num_cell);
for i=1:num_cell
    I_Data_final{i}= [mean( I_Data(:,loc(i):loc(i)+num_each_cell{i}-1)')'];
    I_C_Data_final{i}= [mean( I_C_Data(:,loc(i):loc(i)+num_each_cell{i}-1)')'];
end
delete('*.abf');
I_C_Data_final_image=zeros(8:length(I_C_Data_final));
for i=1:length(I_C_Data_final)
    I_Data_final_image(:,i)=I_Data_final{i};
    I_C_Data_final_image(:,i)=I_C_Data_final{i};
end
a = 1;
j = 1;
RESULT(1:8,1) = I_Data(1:8,1);
R{1,1} = CellTYPE{1};
for i = 2 : filenameP1_Length
    if ( CellType_num(1,i) == CellType_num(1,i-1))
        a = a + 1;
        RESULT(j:j+7,a) = I_Data(1:8,i);
    else
        j = j + 9;
        a = 1;
        RESULT(j:j+7,a) = I_Data(1:8,i);
        R{j,1} = CellTYPE{i};
    end
end

% Plotting heat maps
clc;
image(I_C_Data_final_image)
set(gca,'xtick',[]);
colorbar

