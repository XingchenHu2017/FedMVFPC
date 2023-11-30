%----------------------------------------------1---------------------------------------------------------------------------------------
% Contributed by Xingchen Hu
% Ref:
% [1]
%--------------------------------------------------------------------------------------------------------------------------------------

function [outU,outV,outAlpha,outObj,outNumIter] = federated_multi_FCMCP(sub_data,d,U0,V0,Alpha,q,mm,numview,maxIter)
% [~,n] = size(U);
thresh = 10^-7;
obj = zeros(maxIter,1);
sub_obj = zeros(maxIter,length(sub_data));
cur_Alpha = repmat(Alpha,1,length(sub_data));

cur_U = U0;
cur_V = V0;
% cur_V = zeros(d,size(V0{1},2));
% for subset_index = 1:length(sub_data)
%     cur_V_temp = ones(d,size(V0{1},2));
%     cur_V_temp(1:size(V0{1},1),:) = V0{subset_index};
%     cur_V = cur_V+cur_V_temp/length(sub_data);
% end
% [record_V{1},PS] = mapstd(cur_V,0,1);

% -----------------
for t = 1:maxIter
    
    Alpha = cur_Alpha;    
    U = cur_U;
    V = cur_V;
    
    for subset_index = 1:length(sub_data)
        for p=1:numview
            X{p} = mapstd(sub_data{subset_index}{p},0,1); %mapping each row’s means to 0 and deviations to 1
        end
        num_subdata(subset_index, 1) = size(X{1}, 2);
        Alpha = cur_Alpha(:,subset_index);
        
        %-------- update W when fixed U, V and Alpha--------%
        for p=1:numview
            Up = cur_U{subset_index}.^mm;
            C = X{p}*Up'*V';
            [S,~,L] = svd(C,'econ');
            W{p} = S*L';
        end
        cur_W{t,subset_index} = W;
        
        %-------- update U when fixed V and Alpha--------%
        [U,D] = updateU(X,W,V,Alpha,q,mm,numview);
        [~,n] = size(U);
        cur_U{:,subset_index} = U;
        
        %-------- update V when fixed U and Alpha--------%
        Ut = cur_U{subset_index};
        
        for p = 1:numview
            Vt{p} = updateV(sub_data{subset_index}{p},Ut,mm);
        end
        % record cluster centers in each view
        part_Vt{t,subset_index} = Vt;   
        
        V_temp = zeros(size(W{1},2),size(Ut,1));
        for p = 1:numview
            Ut = Ut.^mm;
            V_temp = V_temp + Alpha(p)^q*W{p}'*X{p} * Ut';
        end
        [S,~,L] = svd(V_temp,'econ');
        V = S*L';
        % record consensus cluster centers for federated learning
        part_V{t,subset_index} = V;   
        
        %-------- update Alpha when fixed U and V--------%
        Alpha = updataAlpha(X,W,U,V,q,mm,numview);
        cur_Alpha(:,subset_index) = Alpha;
        
        %------- calculate the obj --------%
        for p = 1:numview
            D{p} = pdist2(X{p}',(W{p}*V)');
            for i = 1:n
                sub_obj(t,subset_index) = sub_obj(t,subset_index) + (Alpha(p)^q).*D{p}(i,:)*(U(:,i).^mm);
            end
        end
    end
    
    num_of_all_data = sum(num_subdata);
    weight_per_subset = num_subdata / num_of_all_data;
    for subset_index = 1:length(sub_data)
        temp1_V = part_V{t,subset_index};
        sub_V{subset_index,1} = temp1_V;
    end
    temp_data = zeros(size(V,1),size(V,2));
    view_data = sub_V;
    for subset_index = 1:length(sub_data)
        temp_data = temp_data + view_data{subset_index}*weight_per_subset(subset_index);
    end
    cur_V = temp_data;
    clearvars temp_data
    record_V{t+1,:} = cur_V;
    
    %-------- convergence condition ---------%
    obj(t) = sum(sub_obj(t,:));
    if(t > 1)
        diff = obj(t-1)-obj(t);
        if(diff < thresh)
            break;
        end
    end    
end

outObj = obj;
outNumIter = t;
V = record_V{end,:};
W = cur_W{end,:};
outU = [];
for subset_index = 1:length(sub_data)
    for p=1:numview
        X{p} = mapstd(sub_data{subset_index}{p},0,1);
    end
    num_subdata(subset_index, 1) = size(X{1}, 2);
    [tempU,~] = updateU(X,W,V,Alpha,q,mm,numview);
    outU = [outU tempU];
    
    for p = 1:numview
        Vt{p} = updateV(sub_data{subset_index}{p},tempU,mm);
    end
    part_Vt{length(record_V),subset_index} = Vt;
end

% record cluster centers in each view for each iteration
for iter = 1:size(part_Vt,1)
    for subset_index = 1:length(sub_data)
        temp1_Vt = part_Vt{iter,subset_index};
        for p = 1:numview
            sub_V{subset_index,p} = temp1_Vt{p};
        end
    end
    for p = 1:numview
        temp_data = zeros(size(Vt{p},1),size(Vt{p},2));
        view_data = sub_V(:,p);
        for subset_index = 1:length(sub_data)
            temp_data = temp_data + view_data{subset_index}*weight_per_subset(subset_index);
        end
        outV{iter}{p} = temp_data;
        clearvars temp_data
    end
end
outAlpha = cur_Alpha;