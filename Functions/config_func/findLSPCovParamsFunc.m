function param = findLSPCovParamsFunc(param)
diary(['log/findLSPCovParamsExperiment_', ...
    char(datetime('today')), '.txt']);

findLSPStr = ['LSP_cov_',param.datasetType,'_noise_type_',param.maskStr,...
    '_cov_type', param.covStr];


findLSPDir = fullfile(param.outputStr, 'findLSPcov');

if ~exist(findLSPDir,'dir')
    mkdir(findLSPDir);
end

param.findLSPStr = fullfile(findLSPDir,findLSPStr);

param.lineParams.eps1 = 1e-6;
param.lineParams.eps2 = 1e-6;
param.lineParams.eps3 = 1e-6;
param.lineParams.max_iter = 5;
param.lineParams.gridInterval = [1e-4,1;1e-4,1;1e-4,1];
param.lineParams.gridNums = 5*ones(3,1);

end

