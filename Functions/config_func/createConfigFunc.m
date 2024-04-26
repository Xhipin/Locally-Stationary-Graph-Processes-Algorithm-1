function param = createConfigFunc(expFunc)

param = struct();
configType = func2str(expFunc);

iscreateDataset = strcmp(configType, 'createDatasetFunc');
iscreateDataset = iscreateDataset || strcmp(configType, 'createAFUSFunc');
iscreateDataset = iscreateDataset || strcmp(configType, 'createtvminFunc');
iscreateDataset = iscreateDataset || strcmp(configType, 'createIRFunc');
iscreateDataset = iscreateDataset || strcmp(configType, 'configPlots');
iscreateDataset = iscreateDataset || strcmp(configType, 'marquesFunc');


param.isMultiple = strcmp(configType, 'numRealizationMultipleFunc');

iscreateMeta = strcmp(configType, 'metaParamsFunc');
iscreateMeta = iscreateMeta || strcmp(configType, 'KQParamsFunc');
iscreateMeta = iscreateMeta || strcmp(configType, 'clusterMetaFunc');
iscreateMeta = iscreateMeta || strcmp(configType, 'clusterConfigFunc');

addpath(genpath('config_scripts'));

param.file_i = 'Input';
param.file_mat = 'mat_files';
param.file_o = 'Output';
param.datasetType = 'molene';

disp(['++++ Dataset: ', param.datasetType,' ++++']);

param.file_i = fullfile(param.file_i, param.datasetType);

try
    assert(exist(fullfile(param.file_mat,param.file_i),'dir'))
catch
    mkdir(fullfile(param.file_mat,param.file_i));
end

param = generalParamsFunc(iscreateMeta, param);
param = experimentParamsFunc(iscreateMeta, iscreateDataset, param);
param = expFunc(param);

end

