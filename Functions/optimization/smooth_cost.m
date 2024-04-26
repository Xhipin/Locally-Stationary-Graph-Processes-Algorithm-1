function temp_sum = smooth_cost(Gamma, lambda_G, UG, Z, N, Cl)
%SMOOTH_COST Summary of this function goes here
%   Detailed explanation goes here
temp_sum = 0;
for i = 1:N
    for k = 1:Cl
        
        temp_sum = temp_sum + lambda_G(i)*UG(:,i)'* Z(:,:,k)* Gamma * Z(:,:,k)' * UG(:,i);
        
    end
end
end

