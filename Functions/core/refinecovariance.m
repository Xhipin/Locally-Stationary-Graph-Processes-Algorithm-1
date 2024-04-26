function Cxr = refinecovariance(Cx, lambda)

if  diff(size(Cx))
    error("Cx should be a square matrix!!");
end
N = size(Cx,1);
    cvx_begin quiet
    
        variable Cxr(N,N) symmetric
        Cxr == semidefinite(N);
        minimize( norm(Cx-Cxr,2) +  lambda * norm(Cxr,1));
      
    cvx_end

end

