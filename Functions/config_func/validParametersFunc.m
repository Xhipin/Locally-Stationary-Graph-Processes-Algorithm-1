function param = validParametersFunc(param)
diary(['log/validParametersExperiment_', ...
    char(datetime('today')), '.txt']);

mu_two = 0;
mu_three = 0;
mu_four = 0;

param.alternatingParams.mu_two = mu_two;
param.alternatingParams.mu_three = mu_three;
param.alternatingParams.mu_four = mu_four;
param.alternatingParams.vort = true;

end

