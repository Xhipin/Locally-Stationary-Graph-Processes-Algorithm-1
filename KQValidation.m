function KQValidation()
clc;
close all;
clear;
run load_func.m
param = createConfigFunc(@validParametersFunc);

alternatingParams = param.alternatingParams;
%% Validate Parameters

for i = param.numDataArray
    load([param.saveStr,'_numData_', ...
        num2str(i),'.mat'], ...
        'saveCell')
    saveAux = saveCell;
    saveCell = cell(size(saveAux));
    trainInfo = saveAux{1}.trainInfo;

    j = 1;
    for train = trainInfo
        mask = saveAux{j}.dataStruct.mask;

        data = param.m.signal;

        [Rx, n_Rx] = allRxCalculator(data, mask, param.covType);
        alternatingParams.x_local = param.m.signal;


        data(mask == 0 | mask == 2) = NaN;

        alternatingParams.data = data;
        alternatingParams.mask = mask;
        alternatingParams.Rx = Rx;
        alternatingParams.n_Rx = n_Rx;

        saveStruct = struct();
        saveStruct.dataStruct = struct();

        saveStruct.dataStruct.RxBulk = Rx;
        saveStuct.dataStruct.covString = param.covStr;
        saveStuct.dataStruct.n_Rx = n_Rx;
        saveStruct.QClError = zeros(param.MAX_Cl,param.MAX_Q);

        for Cl = 1:param.MAX_Cl
            for Q = 1:param.MAX_Q

                fprintf(['\n++++ Train Percentage: %f, ' ...
                    'Data Number: %f, Q: %f, Cl: %f, ' ...
                    'Covariance Type: %s ++++\n'], ...
                    train, i, Q, Cl, param.covStr);


                alternatingParams.Q = Q;
                alternatingParams.Cl = Cl;
                Z = constructZ(param.m.N,Cl);
                L = constructL(param.m.N,Q,param.m.laplacianMat);

                alternatingParams.L = L;
                alternatingParams.Z = Z;

                g = param.unnorm_LG(:,2:2+Cl-1);
                g = g(:);
                Gamma = g*g';
                if alternatingParams.gb == 0
                    alternatingParams.initialValue = Gamma;
                else
                    alternatingParams.initialValue = B;
                end
                saveStruct.QClError(Cl,Q) = ...
                    alternatingOptimizationWrapperLast(alternatingParams);
            end
        end
        [QArray, ClArray] = meshgrid(1:param.MAX_Q,1:param.MAX_Cl);
        [~,indx] = min(saveStruct.QClError(:));
        QArray = QArray(:);
        ClArray = ClArray(:);

        saveStruct.Q = QArray(indx);
        saveStruct.Cl = ClArray(indx);

        saveCell{j} = saveStruct;

        j = j + 1;
    end
    save([param.validStr,'_numData_', ...
        num2str(i),'.mat'], ...
        'saveCell');
end



end

