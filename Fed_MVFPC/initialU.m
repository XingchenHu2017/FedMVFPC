%--------------------------------------------------------------------------------------------------------------------------------------
% Contributed by Jinglin Xu
% Ref: 
% [2] Discriminatively Embedded K-Means for Multi-view Clustering. (CVPR,2016)
% [3] Robust and Sparse Fuzzy K-Means Clustering. (IJCAI2016)
% [5] https://github.com/ZJULearning/MatlabFunc/tree/master/Clustering
%--------------------------------------------------------------------------------------------------------------------------------------

function [U0,V0] = initialUV(X,p,c,mm,numview)

% % ------ kmeans initialization --------%
% for p = 1:numview
%     [label,k_center] = litekmeans(X{p}',c);   
%     V0{p} = k_center';   
%     Label{p} = label;
% end
% if numview>=2
% U0 = make_G_max(Label{2});
% else
% U0 = make_G_max(Label{1});    
% end
% U0 = U0';   

% ------ random initialization --------%
if p == 1
    data = X;
else
    data = X{randi(p)};
end
% data = X;
for i = 1:numview
    min_v = (min(data{i},[],2))';
    max_v = (max(data{i},[],2))';
    for j = 1:c
        prot(j,:) = min_v + rand()*(max_v - min_v);
    end
    V0{i} = prot';
     clearvars prot
end
for p = 1:size(X,2)
    data = X{p};
    t = 2;
    D{t} = pdist2(data{t}',V0{t}');
    H = D{t};
    
    H = H';
    temp = H.^(-2/(mm-1));
    U0{p} = temp./(ones(c, 1)*sum(temp));
end
 




