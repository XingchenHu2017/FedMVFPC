clc
clear

% load('data.mat')
num = 1440;
Indices = crossvalind('Kfold', num, 5);
for i = 1:5
    k = 1;
    t = 1;
    for j = 1:num
        if Indices(j) ~= i
            flag1(k) = j;
            k = k+1;
        else
            flag2(t) = j;
            t = t+1;
        end
    end
    Trainflag{i} = flag1;
    Testflag{i} = flag2;
end
save('flag_group.mat','Trainflag','Testflag')



% Test_flag = 1:50;
% for i = 1:10
% Train_flag = 51+50*(i-1):100+50*(i-1);
% Trainflag{i} = Train_flag;
% 
% Testflag{i} = Test_flag;
% end
% save('flag_group.mat','Trainflag','Testflag')