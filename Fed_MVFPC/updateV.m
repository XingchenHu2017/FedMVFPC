%-------------------------------------------------------------------------------------------------------------------------------------
% Contributed by Xingchen Hu
% Ref:
% [1] 
%--------------------------------------------------------------------------------------------------------------------------------------

function V = updateV(X,Ut,mm)

[m,~] = size(X);

Ut = Ut.^mm;
Vup = X * Ut';          
Vdown = sum(Ut,2);     
V = Vup./repmat(Vdown',m,1); 

% function V = updateV(X,W,Ut,Alpha,q,mm,numview)
% 
% Vup = zeros(size(W{1},2),size(Ut,1));
% for p = 1:numview
%     Ut = Ut.^mm;
%     Vup = Vup + Alpha(p)^q*W{p}'*X{p} * Ut';
% end
% V = Vup;

% 
% Vup = zeros(size(W{1},2),size(Ut,1));
% Vdown = zeros(size(Ut,1),1);
% for p = 1:numview
%     Ut = Ut.^mm;
%     Vup = Vup + Alpha(p)^q*W{p}'*X{p} * Ut';
%     Vdown = Vdown + Alpha(p)^q*sum(Ut,2);
% end
% V = Vup./repmat(Vdown',size(W{1},2),1);

