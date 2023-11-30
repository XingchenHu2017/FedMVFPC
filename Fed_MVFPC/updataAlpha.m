function Alpha = updataAlpha(X,W,U,V,q,mm,numview)

for p = 1:numview
    D{p} = pdist2(X{p}',(W{p}*V)');
    A(p) = trace(D{p}*(U.^mm));
    alpha_up(p) = A(p)^(1/(1-q));
end

alpha_down = sum(alpha_up);
Alpha = alpha_up./alpha_down;


