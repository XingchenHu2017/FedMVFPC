%--------------------------------------------------------------------------------------------------------------------------------------
% Contributed by Xingchen Hu
% Ref:
% [1]
%--------------------------------------------------------------------------------------------------------------------------------------

function [U0,V0] = initialUV(X,d,c,q,mm,numview)

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

% ------ kmeans initialization --------%
% for i = 1:numview
%     fea_num(i) = size(X{1}{i},1);
% end
% [~,t] = min(fea_num);

for p = 1:size(X,2)
    data = X{p};
    
    for t = 1:numview
        [label,k_center] = litekmeans(data{t}',c);
%         low_bound = min(data{t}');
%         up_bound = max(data{t}');
%         matx = [random('Uniform',low_bound,up_bound);random('Uniform',low_bound,up_bound);random('Uniform',low_bound,up_bound);random('Uniform',low_bound,up_bound);];
%         [label,k_center] = litekmeans(data{t}',c,'start',matx,'maxiter',1);
%         Vp{t} = k_center';
        Label{t} = label;
%         Label{t} = randi([1,4],10000,1);
        k_center_all{t} = k_center;

    end
    
    if numview>=2
    temp_U = make_G_max(Label{2});
    else
    temp_U = make_G_max(Label{1});
    end
% %     U0{p} = temp_U';
    temp = rand(4,10000);
    U0{p} = temp./sum(temp);
    
    V0 = zeros(d,c);
    for i = 1:d
        for j = 1:c
            if i == j
                V0(i,j) = 1;
            end
        end
    end
    %%
%     temp = rand(d,c);
%     V0 = temp./sum(temp);
end

% % ------ kmeans initialization --------%
% % for i = 1:numview
% %     fea_num(i) = size(X{1}{i},1);
% % end
% % [~,t] = min(fea_num);
% 
% for p = 1:size(X,2)
%     data = X{p};
%     
%     for t = 1:numview
%         [~,k_center] = litekmeans(data{t}',c);
%         Vp{t} = k_center';
%         W{t} = zeros(d,size(Vp{t},1));
%         W{t}(:,1:d) = eye(d);
%     end
%     [~,n] = size(data{1});   [~,c] = size(Vp{1});   H = zeros(n,c);
%     
%     for t = 1:numview
%         D{t} = pdist2(data{t}',Vp{t}');
%         H = H+((1/numview)^q)*D{t};
%     end
%     H = H';
%     temp = H.^(-2/(mm-1));
%     temp_U = temp./(ones(c, 1)*sum(temp));
%     temp_U(isnan(temp_U)) = 1;
%     U0{p} = temp_U;
%     
%     V0 = zeros(d,c);
%     for i = 1:d
%         for j = 1:c
%             if i == j
%                 V0(i,j) = 1;
%             end
%         end
%     end   
% end

% V0 = zeros(d,size(Vp{1},2));
% for p = 1:size(X,2)
%     V0_temp = ones(d,size(Vp{1},2));
%     V0_temp(1:size(Vp{1},1),:) = Vp{p};
%     V0 = V0+V0_temp/length(X);
% end
% 
% for p = 1:size(X,2)
%     data = X{p};
%     [~,n] = size(X{1});   [~,c] = size(V0);   H = zeros(n,c);
%     
%     for t = 1:numview
%         D{t} = pdist2(data{t}',V0');
%         H = H+((1/numview)^q)*D{t};
%     end
%     H = H';
%     temp = H.^(-2/(mm-1));
%     temp_U = temp./(ones(c, 1)*sum(temp));
%     temp_U(isnan(temp_U)) = 1;
%     U0{p} = temp_U;
end


% ------ random initialization --------%
% for p = 1:size(X,2)
%     data = X{p};
%     for t = 2
%         min_v = (min(data{t},[],2))';
%         max_v = (max(data{t},[],2))';
%         for j = 1:c
%             prot(j,:) = min_v + rand()*(max_v - min_v);
%         end
%         V0{p} = prot';
%         clearvars prot
% 
%         D{t} = pdist2(data{t}',V0{p}');
%         H = D{t};
% 
%         H = H';
%         temp = H.^(-2/(mm-1));
%         U0{p} = temp./(ones(c, 1)*sum(temp));
%     end
% end





