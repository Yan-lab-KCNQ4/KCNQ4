function main
SamplePath = 'D:\A研究生\A实验室\KCNQ4\所有数据\S6  done';
cd(SamplePath);
files = dir(SamplePath);
length = size(files,1);
names = files(3:length);
NAMES = {names.name};
LENGTH = size(NAMES,2);
row1 = 1;
row2 = 1;
for ii = 1 : LENGTH
     AA = NAMES{ii};
     FULLNAME = [SamplePath,'\',AA];
     cd('D:\A研究生\A实验室\KCNQ4\计算\V12_SINGLE');
     [out1, out2] = Vstest(FULLNAME);
     ROW = size(out2,1);
     COL = size(out2,2);
     ROW2 = size(out1,1);
     DD(row1:row1+ROW-1,1:COL) = out2;
     NN(row2:row2+ROW2-1,1) = out1(1:ROW2);
     row2 = row2 + ROW + 1;
     row1 = row1 + ROW + 1;
     clear AA;
     clear FULLNAME;
     clear out1;
     clear out2;
end
end
