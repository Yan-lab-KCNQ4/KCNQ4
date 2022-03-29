clear all
clc
prompt = 'Please copy and paste the file path ';
str = input(prompt,'s');
Source_Pathname=[str,'\*.abf']
Allfilename=dir(Source_Pathname);
% WORK PATH
DST_Pathname='D:\CALCULATE\V12_CO';
filenamelength=length(Allfilename);
for i=1:filenamelength
    copyfile([str,'\',Allfilename(i).name],DST_Pathname);
end
filenameP1={};
filenameP2={};
j=1;
k=1;
for i=1:filenamelength
    filename= Allfilename(i).name;
    filenameafter=extractAfter(filename,15);
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
    filenameafter=extractAfter(open_filename,13);
    filenamenamebefore=extractBefore(filenameafter,3);
    capacitanceP1(i)=str2num(filenamenamebefore);
end
for i=1:filenameP2_Length
    open_filename=filenameP2{i};
    dataP2{i}=abfload(open_filename,'start',100,'sweep','a');
    filenameafter=extractAfter(open_filename,13);
    filenamenamebefore=extractBefore(filenameafter,3);
    capacitanceP2(i)=str2num(filenamenamebefore);
end
Para_dataP1=size(dataP1{1});
I={};
I_C_ratio={};
for i=1:filenameP1_Length
    j=1:8;
    I{i}(j)=mean(dataP1{i}(11299:11301,2,j));
    I_C_ratio{i}(j)=mean(dataP1{i}(11299:11301,2,j))/capacitanceP1(i);
end
CellType={};
for i=1:filenameP1_Length
    CellType_after=extractAfter(filenameP1{i},3);
    CellType_before=extractBefore(CellType_after,3);
    CELL = extractAfter(CellType_before,1);
    BEFORE = extractBefore(CellType_before,2);
    NUM = extractBefore(filenameP1{i},4);
    CellType{i}= CellType_before;
    NAME = [BEFORE,NUM,CELL,'+WT'];
    CellTYPE{i} = NAME;
end
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
clc;
[max_a,index]=max(I_Data,[],1);
IMAX=I_Data./max_a;
% C:\Users\xhyan\Desktop\新建文件夹 (2)
x = (-100 : 20 : 40)';
for i = 1 : filenameP1_Length
    y = flipud(IMAX(:,i));
    f = fittype('1-1/(1+exp((x-c)/k))','independent',{'x'},'coefficients',{'c','k'});
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Lower = [-60 1];
    opts.StartPoint = [-60 5];
    opts.Upper = [0 37];
    cfun = fit(x,y,f,opts);
    result(1,i) = cfun.c;
    result(2,i) = cfun.k;
%     xi = (-100 : 20 : 40)';
%     yi = cfun(xi);
%     figure
%     plot(x,y,'r*',xi,yi,'b-');
end
rr = [IMAX;result];
j = 1;
a = 1;
RESULT(1:10,1) = rr(1:10,1);
R{1,1} = CellTYPE{1};
for i = 2 : filenameP1_Length
   
    if ( CellType_num(1,i) == CellType_num(1,i-1))
        a = a + 1;
        RESULT(j:j+9,a) = rr(1:10,i);
        
    else
        j = j + 11;
        a = 1;
        RESULT(j:j+9,a) = rr(1:10,i);
        R{j,1} = CellTYPE{i};
    end
end

% image(I_C_Data_final_image)
% C:\Users\xhyan\Desktop\新建文件夹 (3)
% set(gca,'xtick',[]);
colorbar

