%--------------------------------------------------------------------------------------------------------------------------------------
% Contributed by Xingchen Hu
% Ref: 
% [1] 
%--------------------------------------------------------------------------------------------------------------------------------------

function [U0,V0] = initialV(X,p,c,mm,numview)

% % ------ kmeans initialization --------%
data = X{p};
for i = 1:numview
    [~,k_center] = litekmeans(data{i}',c); 
    temp_center = k_center;
    V0{i} = temp_center';   
end
for p = 2
    D{p} = pdist2(data{p}',V0{p}');   
    H = D{p};
end
H = H';
temp = H.^(-2/(mm-1));
U0 = temp./(ones(c, 1)*sum(temp)); 




