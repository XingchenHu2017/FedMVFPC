%-------------------------------------------------------------------------------------------------------------------------------------
% Contributed by Xingchen Hu
% Ref:
% [1] Federated Multi view Fuzzy C Means Clustering IEEE TFS 2023
% [2] Multi-View K-Means Clustering With Adaptive Sparse Memberships and Weight IEEE TKDE 2022 
%--------------------------------------------------------------------------------------------------------------------------------------
clear all; clc;

% --------------- data ----------------- %
data_name = 'COIL20'; 
load(strcat('../',data_name,'/data.mat')); 
addpath(genpath('./'));

%--------- parameters ---------%
p = 5;  %number of clients
rStart = 0;     rNum = 1;         rStride = 0.1;    % fuzzification coefficient
times = 30;     maxIter = 50;     c = max(Y);    numview = length(X);
%------------------------------------------
Alpha = ones(numview,1)/numview;
%------------------------------------------
AC = zeros(times,1);               NMI = zeros(times,1);
meanAC = zeros(rNum,1);    meanNMI = zeros(rNum,1);
stdAC = zeros(rNum,1);         stdNMI = zeros(rNum,1);
timer = zeros(times,1);         purity = zeros(times,1);
meanTime = zeros(rNum,1);    meanPur = zeros(rNum,1);
stdTime = zeros(rNum,1);         stdPur = zeros(rNum,1);

for tt = 1:numview
    X{tt} = X{tt};
end

%split the training data into P subsets
% rng('default');
sub_num = rand(1, p);
sub_num = sub_num / sum(sub_num);
sub_num = cumsum(sub_num);
sub_num = [0,round(sub_num*size(X{tt},2))];
idx = randperm(size(X{tt},2));

for tt = 1:numview
    Data = X{tt};
    for i = 1:size(Data,2)
        temp(:,i) = Data(:,idx(i));
        temp_Y(i,1) = Y(idx(i));
    end
    multi_temp{tt} = temp;
    clearvars temp
end
Y = temp_Y;     %reform class label for each subset

% Data = temp;
k = 1;
nn = 0;
for i = 2:p+1
    for tt = 1:numview
        Data =  multi_temp{tt};
        temp_Data{tt} = Data(:,sub_num(i-1)+1:sub_num(i));
    end
    nn = nn+size(temp_Data{1},2);
    sub_Data{k} = temp_Data;
    k = k+1;
end

% The main part of federated Multi-view FCM

q = 2;
for r = 1:19
    mm = 1 + rStride*r;
    fprintf('%s m = %0.2f \n',data_name,mm)
    for k = 1:times
        
        %---------initialization---------%
        % X: m_dimensions*n_samples, U0:c*n, V0{p}:m*c, outU:c*n, outV{p}:m*c
        [U0,V0] = Fed_initialV(sub_Data,p,c,mm,numview);
        tic
        [outU,outV,outAlpha,outObj,outNumIter] = federated_multi_FCM(sub_Data,V0,Alpha,c,q,mm,numview,maxIter);
        timer(k)  = toc;
         
         %--------- results ----------%
        [~,label_out] = max(outU);
        res = Clustering8Measure(Y,label_out');
        AC(k)  = res(1);
        NMI(k) = res(2);
        purity(k) = res(3);
    end
    meanAC(r) = mean(AC);           meanNMI(r) = mean(NMI);
    meanPur(r) = mean(purity);      meanTime(r) = mean(timer);
    stdAC(r) = std(AC);                  stdNMI(r) = std(NMI);
    stdPur(r) = std(purity);
end