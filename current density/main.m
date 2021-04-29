function main
SamplePath = 'D:\A研究生\A实验室\KCNQ4\所有数据\C';
cd(SamplePath);
files = dir(SamplePath);
length = size(files,1);
names = files(3:length);
NAMES = {names.name};
LENGTH = size(NAMES,2);
row1 = 1;
col1 = 1;
row2 = 1;
for ii = 376 : 378
     AA = NAMES{ii};
     FULLNAME = [SamplePath,'\',AA];
     cd('D:\A研究生\A实验室\KCNQ4\计算\electric current');
     [out1,out2,out3] = test(FULLNAME);
     ROW = size(out2,1);
     COL = size(out2,2);
     COL2 = size(out1,2);
     ROW2 = size(out3,1);
     DD(row1:row1+ROW-1,1:COL) = out2;

     NN(1:8,col1:col1+COL2-1) = out1(1:8,1:COL2);
     NAME(row2:row2+ROW2-1,1) = out3(1:ROW2);
     col1 = col1 + COL2;
     row1 = row1 + ROW + 1;
     row2 = row2 + ROW2 + 8;
     clear AA;
     clear FULLNAME;
     clear out1;
     clear out2;
end
end
