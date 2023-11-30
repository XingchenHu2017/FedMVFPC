%----------------------------------------------1---------------------------------------------------------------------------------------
% Contributed by Xingchen Hu
% Ref:
% [1]
%--------------------------------------------------------------------------------------------------------------------------------------

function [outU,outV,outAlpha,outObj,outNumIter] = MV_FCM(sub_data,V,Alpha,c,q,mm,numview,maxIter)
% [~,n] = size(U);
thresh = 10^-7;
gamma = 1;
obj = zeros(maxIter,1);
cur_Alpha = repmat(Alpha,1,length(sub_data));
cur_V = V;
record_V{1} = cur_V;
% -----------------
for t = 1:maxIter
    
    V = cur_V;
    
    for subset_index = 1:length(sub_data)
        X = sub_data{subset_index};
        num_subdata(subset_index, 1) = size(X{1}, 2);
        Alpha = cur_Alpha(:,subset_index);
        
        %-------- update U when fixed V and Alpha--------%
        [U,D] = updateU(X,V,Alpha,q,mm,numview);
        [~,n] = size(U);
        part_U{t,subset_index} = U;
        
        %-------- update Alpha when fixed U and V--------%
        Alpha = updataAlpha(X,U,V,q,mm,numview);
        cur_Alpha(:,subset_index) = Alpha;
        
        %-------- update V when fixed U and Alpha--------%
        for p = 1:numview
            U_cur = part_U{t,subset_index};
            center = (cur_V{p})';
            dim = size(X{p},1);
            for i = 1:c
                tmp_membership_power = power(U_cur(i, :), mm);
                tmp_center_minus_data = center(i, :) - (X{p})';
                mid_membership_power = repmat(tmp_membership_power', 1, dim);
                oneview_prototype_gradient(1,(i-1)*dim+1:i*dim) = mean(mid_membership_power .* tmp_center_minus_data) * 2; % *(Alpha(p)^q)
            end
            cur_prototype_gradient{p}(subset_index,:) = oneview_prototype_gradient;
            clearvars oneview_prototype_gradient
        end
        
        %         temp_Alpha = part_Alpha{t,subset_index};
        %         cur_Alpha = sub_alpha+temp_Alpha*weight_per_subset(subset_index);
        
        %------- calculate the obj for each sub-dataset--------%
        for p = 1:numview
            D{p} = pdist2(X{p}',cur_V{p}');
            for i = 1:n
                obj(t) = obj(t) + (Alpha(p)^q).*D{p}(i,:)*(U(:,i).^mm);
            end
        end       
        
    end
    num_of_all_data = sum(num_subdata);
    weight_per_subset = num_subdata / num_of_all_data;
    for p = 1:numview
        dim = size(X{p},1);
        gradient_cur_round{p} = sum(repmat(weight_per_subset, 1, dim*c) .* cur_prototype_gradient{p},1);
        gradient_cur_round{p} = reshape(gradient_cur_round{p},dim,c);
        cur_V{p} = cur_V{p} - gamma * gradient_cur_round{p};
    end
    %    sub_alpha = zeros(1,size(part_Alpha{1},2));
    %     for subset_index = 1:length(sub_data)
    %         temp_Alpha = part_Alpha{t,subset_index};
    %         sub_alpha = sub_alpha+temp_Alpha*weight_per_subset(subset_index);
    %     end
    %     cur_Alpha = sub_alpha/sum(sub_alpha);
    record_V{t+1,:} = cur_V;
    
    %-------- convergence condition ---------%
    if(t > 10)
        diff = obj(t-1)-obj(t);
        if(diff < thresh)
            break;
        end
    end
    
end
outObj = obj;
outNumIter = t;
% outU = part_U;
V = record_V{end,:};
outU = [];
for subset_index = 1:length(sub_data)
    X = sub_data{subset_index};
    num_subdata(subset_index, 1) = size(X{1}, 2);
    [tempU,~] = updateU(X,V,Alpha,q,mm,numview);
    outU = [outU tempU];
end
outV = record_V;
outAlpha = cur_Alpha;