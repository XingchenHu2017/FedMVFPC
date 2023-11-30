%-------------------------------------------------------------------------------------------------------------------------------------
% Contributed by Jinglin Xu
% Ref:
% [1] Multi-View K-Means Clustering on Big Data. (IJCAI,2013).
% [2] Discriminatively Embedded K-Means for Multi-view Clustering. (CVPR,2016)
% [3] Robust and Sparse Fuzzy K-Means Clustering. (IJCAI2016)
% [4] A new simplex sparse learning model to measure data similarity for clustering (AAAI2015)
%--------------------------------------------------------------------------------------------------------------------------------------

function [Ut,D] = updateU(X,V,Alpha,q,mm,numview)

[~,n] = size(X{1});   [~,c] = size(V{1});
Ut = zeros(c,n);   B = zeros(c,n);   H = zeros(n,c); 

for p = 1:numview
    D{p} = pdist2(X{p}',V{p}');   
    H = H+(Alpha(p)^q)*D{p};
end
H = H';
temp = H.^(-2/(mm-1));
Ut = temp./(ones(c, 1)*sum(temp));

