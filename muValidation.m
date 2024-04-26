function muValidation()

run load_func.m

param = createConfigFunc(@findLSPCovParamsFunc);
alternatingParams = param.alternatingParams;
lineParams = param.lineParams;
alternatingParams.x_local = param.m.signal;

for i = param.numDataArray
    load([param.validStr,'_numData_', ...
        num2str(i),'.mat'], ...
        'saveCell');
    validCell = saveCell;

    load([param.saveStr,'_numData_', ...
        num2str(i),'.mat'], ...
        'saveCell');
    saveAux = saveCell;
    trainInfo = saveAux{1}.trainInfo;

    j = 1;

    for train = trainInfo
        if strcmp(param.datasetType, 'synthetic_noise')
            param.m.signal = saveAux{j}.dataStruct.data;
        end
        mask = saveAux{j}.dataStruct.mask;
        data = param.m.signal;
        data(mask == 0) = NaN;
        
        Rx = validCell{j}.dataStruct.RxBulk;

        alternatingParams.data = data;
        alternatingParams.mask = mask;
        alternatingParams.Rx = Rx;

        Q = validCell{j}.Q;
        Cl = validCell{j}.Cl;
        alternatingParams.Q = Q;
        alternatingParams.Cl = Cl;

        fprintf(['\n++++ Train Percentage: %f, Data Number: %f,' ...
            ' Q: %f, Cl: %f, Covariance Type: %s ++++\n'],train, i, ...
            Q, Cl, param.covStr);

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

        saveStruct = struct();
        saveStruct.regStruct = struct();
        saveStruct.dataStruct = struct();
        
        alternatingParams.vort = true;
        tempStruct = gridAlternating(@alternatingOptimizationWrapperLast, ...
            lineParams,...
            alternatingParams);
        alternatingParams.mu_two = tempStruct.x_opt(1);
        alternatingParams.mu_three = tempStruct.x_opt(2);
        alternatingParams.mu_four = tempStruct.x_opt(3);

        saveStruct.regStruct.mu = tempStruct.x_opt;
        saveStruct.regStruct.optimal_f = tempStruct.f_opt;
        saveStruct.regStruct.xVector = tempStruct.xVector;
        saveStruct.regStruct.fVector = tempStruct.fVector;
        saveStruct.regStruct.mode = 'gridSearch_Val';


        saveStruct.dataStruct.RxBulk = Rx;

        alternatingParams.vort = false;
        %% Check the Error on Test
        [Gamma, B, errorPercentage, Rx_found] = ...
            alternatingOptimizationResultsLast (alternatingParams);

        saveStruct.dataStruct.RxFound = Rx_found;
        saveStruct.error = errorPercentage;
        saveStruct.dataStruct.Gamma = Gamma;
        saveStruct.dataStruct.B = B;

        saveCell{j} = saveStruct;

        j = j + 1;
    end
    save([param.findLSPStr,'_numData_', ...
        num2str(i),'.mat'], ...
        'saveCell');

end

end

