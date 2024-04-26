function [Gamma,B,errors] = alternatingOptimization(initialValue, gb, N, Q, Cl, L, Rx, mu_two, mu_three, mu_four, UG, lambda_G, Z, i,j,k,MAX_ITERS,errors)

if gb == 0
    Gamma = initialValue;
    it_check = 1;
elseif gb == 1
    B = initialValue;
    it_check = 0;
end

for iter = 1:MAX_ITERS
    tic
    try
        cvx_begin quiet

        if mod(iter,2) == it_check
            variable B(Q*Cl,Q*Cl) semidefinite
            minimize(joint_cost(B, Gamma, N , Q, Cl, L, Rx) + mu_four * trace(B));

        else
            variable Gamma(N*Cl,N*Cl) semidefinite
            minimize(joint_cost(B, Gamma, N , Q, Cl, L, Rx) + mu_two * smooth_cost(Gamma, lambda_G, UG, Z, N , Cl) + mu_three * trace(Gamma));

        end
        cvx_end
    catch
        fprintf('The problem is infeasible, skipping...\n');

        B = NaN*ones(Q*Cl);
        Gamma = NaN*ones(N*Cl);


        return;
    end

    errors = writeIterationParameters(B,Gamma,i,j,k,iter,it_check,mu_two,mu_three,mu_four,cvx_optval,lambda_G,UG,Z,N,Cl,errors);
    toc
end
end
