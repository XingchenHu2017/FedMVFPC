%--------------------------------------------------------------------------------------------------------------------------------------
% Contributed by Xingchen Hu
% Ref: 
% [1] 
%--------------------------------------------------------------------------------------------------------------------------------------

function [U0,V0] = Fed_initialV(X,p,c,mm,numview)

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

% % ------ kmeans initialization --------%
data = X{randi(p)};
for i = 1:numview
    [~,k_center] = litekmeans(data{i}',c);   
    V0{i} = k_center';   
end
for p = 2
    D{p} = pdist2(data{p}',V0{p}');   
    H = D{p};
end
H = H';
temp = H.^(-2/(mm-1));
U0 = temp./(ones(c, 1)*sum(temp)); 

% ------ random initialization --------%
% data = X{randi(p)};
% % data = X;
% for i = 1:numview
%     min_v = (min(data{i},[],2))';
%     max_v = (max(data{i},[],2))';
%     for j = 1:c
%         prot(j,:) = min_v + rand()*(max_v - min_v);
%     end
%     V0{i} = prot';
%      clearvars prot
% end
% for p = 2
%     D{p} = pdist2(data{p}',V0{p}');   
%     H = D{p};
% end
% H = H';
% temp = H.^(-2/(mm-1));
% U0 = temp./(ones(c, 1)*sum(temp));
 




