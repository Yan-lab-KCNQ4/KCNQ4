function [result] = missense(x)
data = fastaread('D:\A研究生\A实验室\202002-202004\SIFT\sift\KCNQ_gene.txt');
data2 = fastaread('KCNQ_family.txt');
[~,all] = xlsread('D:\A研究生\A实验室\202002-202004\SIFT\sift\ALL.xlsx','A1:V61');
raw = xlsread('D:\A研究生\A实验室\202002-202004\SIFT\sift\raw.xlsx');
score = xlsread('D:\A研究生\A实验室\202002-202004\SIFT\sift\SIFT_new.xls');
s = size(all,1);
kcnqn = data(1).Sequence;%密码子
kcnq4a = data2(1).Sequence;
kcnqna = data2(1).Sequence;%氨基酸
length = size(kcnqn,2)/3;
length2 = size(kcnq4a,2);
n = 1;
new = cell(length,21);
result = cell(length,22);   

for i = 1 : length
    c = kcnqn(n:n+2);
    n = n + 3;  
    for j = 1:s
        if (strcmp(c,all(j,2))==1)
            new(i,1) = all(j,1);
            new(i,2:21) = all(j,3:22);
        end
    end
end

countq4 = 0;
countqn = 0;
j = 1;
K = 0;
for t = 1 :length2
    if (kcnq4a(t) == '-')
        if(kcnqna(t) ~= '-')
            countqn = countqn + 1;
        end
    end
    if (kcnq4a(t) ~= '-')
        countq4 = countq4 + 1;
        if(kcnqna(t) ~= '-')
            countqn = countqn + 1;
            for n = 1 : 20
                if (isnan(raw(countq4,n)))
                    continue;
                end
                if (~isempty(new{countqn,n+1}))
                    result(j,n+3) = {score(countq4,n)};
                    K = K + 1;
                    mis_result(K,4) =  new(countqn,n+1);
                    mis_result(K,3) = {countq4};
                    mis_result(K,2) = {countqn};
                    mis_result(K,1) = new(countqn,1);
                end
            end
            result(j,1) = {countqn};
            result(j,2) = new(countqn,1);
            result(j,3) = {countq4};
%             result(j,1) = 
            j = j + 1;
        end
    end
end
str=string(zeros(K,2));
for i = 1:K
    str(i,1)=strcat(mis_result(i,1),num2str(mis_result{i,2}),mis_result(i,4));
    str(i,2)=strcat(mis_result(i,1),num2str(mis_result{i,3}),mis_result(i,4));
    i = i + 1;
end
end
