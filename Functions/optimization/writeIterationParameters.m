function errors = writeIterationParameters(B,Gamma,i,j,k,iter,it_check,mu_two,mu_three,mu_four,cvx_optval,lambda_G,UG,Z,N,Cl,errors)

if mod(iter,2) == 1

    if it_check == 1
        errors.tr_filt(ceil(iter/2),i,j,k) = trace(B);
        errors.norm_filt(ceil(iter/2),i,j,k) = cvx_optval - mu_four * errors.tr_filt(ceil(iter/2),i,j,k);
        errors.residual_b(ceil(iter/2),i,j,k) = cvx_optval;
        errors.residual(iter,i,j,k) =  errors.residual_b(ceil(iter/2),i,j,k) + mu_two * smooth_cost(Gamma, lambda_G, UG, Z, N, Cl) + mu_three * trace(Gamma);
        fprintf(1,'-- ITERATION %d ---\n',iter);
        fprintf(1,'Iteration %d, Trace B Objective %g\n',iter,errors.tr_filt(ceil(iter/2),i,j,k));
        fprintf(1,'Iteration %d, Norm Objective %g\n',iter,errors.norm_filt(ceil(iter/2),i,j,k));
        fprintf(1,'Iteration %d, Filter (B) Objective Value %g\n\n',iter,errors.residual_b(ceil(iter/2),i,j,k));
        fprintf(1,'Iteration %d, Overall Objective Value %g\n\n',iter, errors.residual(iter,i,j,k));

    else
        errors.sm_cost(ceil(iter/2),i,j,k) = smooth_cost(Gamma, lambda_G, UG, Z, N, Cl);
        errors.tr_gam(ceil(iter/2),i,j,k) = trace(Gamma);
        errors.norm_cost(ceil(iter/2),i,j,k) = cvx_optval - mu_three * errors.tr_gam(ceil(iter/2),i,j,k) - mu_two * errors.sm_cost(ceil(iter/2),i,j,k);
        errors.residual_gamma(ceil(iter/2),i,j,k) = cvx_optval;
        errors.residual(iter,i,j,k) =  errors.residual_gamma(ceil(iter/2),i,j,k) +  mu_four * trace(B);
        fprintf(1,'-- ITERATION %d ---\n',iter);
        fprintf(1,'Iteration %d, Smoothness Objective %g\n',iter,errors.sm_cost(ceil(iter/2),i,j,k));
        fprintf(1,'Iteration %d, Trace Gamma Objective %g\n',iter,errors.tr_gam(ceil(iter/2),i,j,k));
        fprintf(1,'Iteration %d, Norm Objective %g\n',iter,errors.norm_cost(ceil(iter/2),i,j,k));
        fprintf(1,'Iteration %d, Membership (Gamma) Objective Value %g\n\n',iter,errors.residual_gamma(ceil(iter/2),i,j,k));
        fprintf(1,'Iteration %d, Overall Objective Value %g\n\n',iter, errors.residual(iter,i,j,k));
    end
else
    if it_check == 1
        errors.sm_cost(iter/2,i,j,k) = smooth_cost(Gamma, lambda_G, UG, Z, N, Cl);
        errors.tr_gam(iter/2,i,j,k) = trace(Gamma);
        errors.norm_cost(iter/2,i,j,k) = cvx_optval - mu_three * errors.tr_gam(iter/2,i,j,k) - mu_two * errors.sm_cost(iter/2,i,j,k);
        errors.residual_gamma(iter/2,i,j,k) = cvx_optval;
        errors.residual(iter,i,j,k) =  errors.residual_gamma(iter/2,i,j,k) +  mu_four * trace(B);
        fprintf(1,'-- ITERATION %d ---\n',iter);
        fprintf(1,'Iteration %d, Smoothness Objective %g\n',iter,errors.sm_cost(iter/2,i,j,k));
        fprintf(1,'Iteration %d, Trace Gamma Objective %g\n',iter,errors.tr_gam(iter/2,i,j,k));
        fprintf(1,'Iteration %d, Norm Objective %g\n',iter,errors.norm_cost(iter/2,i,j,k));
        fprintf(1,'Iteration %d, Membership (Gamma) Objective Value %g\n\n',iter,errors.residual_gamma(iter/2,i,j,k));
        fprintf(1,'Iteration %d, Overall Objective Value %g\n\n',iter, errors.residual(iter,i,j,k));

    else
        errors.tr_filt(iter/2,i,j,k) = trace(B);
        errors.norm_filt(iter/2,i,j,k) = cvx_optval - mu_four * errors.tr_filt(iter/2,i,j,k);
        errors.residual_b(iter/2,i,j,k) = cvx_optval;
        errors.residual(iter,i,j,k) =  errors.residual_b(iter/2,i,j,k) + mu_two * smooth_cost(Gamma, lambda_G, UG, Z, N, Cl) + mu_three * trace(Gamma);
        fprintf(1,'-- ITERATION %d ---\n',iter);
        fprintf(1,'Iteration %d, Trace B Objective %g\n',iter,errors.tr_filt(iter/2,i,j,k));
        fprintf(1,'Iteration %d, Norm Objective %g\n',iter,errors.norm_filt(iter/2,i,j,k));
        fprintf(1,'Iteration %d, Filter (B) Objective Value %g\n\n',iter,errors.residual_b(iter/2,i,j,k));
        fprintf(1,'Iteration %d, Overall Objective Value %g\n\n',iter, errors.residual(iter,i,j,k));
    end

end

end