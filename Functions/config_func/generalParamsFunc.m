function param = generalParamsFunc(iscreateMeta, param)

if iscreateMeta
    return
end

maskCell = {'SaltPepper', 'NewSinglePointMissing', ...
    'NeighborhoodMissing',...
    'OldSinglePointMissing', 'AWGN', 'None'};

param.maskType = 0;
% param.trainArray = [0,1e-1,0.194,0.376,0.729,1.414];
% param.trainArray = 0;
param.trainArray = 0.1;
% param.trainArray = [2.94345830746739e-05,...
%     8.84606467781643e-05,...
%     0.000265853469320725,...
%     0.000798977508350211,...
%     0.00240119137990029,...
%     0.00721637340557050,...
%     0.0216875862392892,	...
%     0.0651783618241717,	...
%     0.195882511000076,...
% 0.588691661493478];
param.maskStr = maskCell{param.maskType + 1};


fileType = 'meta_data';

extraStr = '';

if param.isMultiple
    realNum = input('Please enter the number of example realizations:');
    extraStr = ['_',num2str(realNum)];

end

param.numData = 10;

matStrCell = {fileType, [param.datasetType,extraStr,'.mat']};
matStr = strjoin(matStrCell, '_');

param.loadStr = fullfile(param.file_mat, [param.file_i, extraStr], ...
    matStr);

param.outputStr = fullfile(param.file_mat, param.file_o, ...
    param.datasetType, param.maskStr);

if ~exist(param.outputStr,'dir')
    mkdir(param.outputStr)
end

if ~exist('log','dir')
    mkdir('log');
end

saveStr = [param.datasetType,'_dataset_noise_type_', param.maskStr];
param.saveStr = fullfile(param.outputStr,saveStr);

end

