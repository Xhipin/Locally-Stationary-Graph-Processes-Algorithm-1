function param = experimentParamsFunc(iscreateMeta, iscreateDataset, param)

if iscreateDataset || iscreateMeta
    return
end

covCell = {'Sample Covariance', 'Label Propagation', 'Corrected',...
    'Linear Interp','Matlab Covariance'};
param.covType = 0;

param.covStr = covCell{param.covType + 1};
validStr =['Q_Cl_choose_',param.datasetType,'_noise_type_',param.maskStr,...
    '_cov_type', param.covStr];

validDir = fullfile(param.outputStr, 'validParameters');

if ~exist(validDir,'dir')
    mkdir(validDir);
end

param.validStr = fullfile(validDir,validStr);

% param.mu_two = 0;
% param.mu_three = 0;
% param.mu_four = 0;
MAX_ITERS = 10;
param.MAX_Q = 10;
param.MAX_Cl = 3;
gb = 0;
param.numDataArray = 3;

load(param.loadStr);
param.m = m;

D = diag(sum(param.m.weightMat));
LG = param.m.laplacianMat;
UG = param.m.graphEigenVectors;
param.W = param.m.weightMat;
lambda_G = param.m.lambda;
N = param.m.N;
x_local = param.m.signal;


[param.unnorm_LG,~] = eig(full(D^(1/2)*LG*D^(1/2)));

errors = struct();
param.x_size = size(x_local);

%% Parameter Struct Construction for Line Search
param.alternatingParams = struct();
param.alternatingParams.gb = gb;
param.alternatingParams.N = N;

param.alternatingParams.UG = UG;
param.alternatingParams.lambda_G = lambda_G;
param.alternatingParams.MAX_ITERS = MAX_ITERS;

param.alternatingParams.LG = LG;
param.alternatingParams.errors = errors;
param.alternatingParams.i = 1;
param.alternatingParams.j = 1;
param.alternatingParams.k = 1;
param.alternatingParams.x_local = x_local;


end

