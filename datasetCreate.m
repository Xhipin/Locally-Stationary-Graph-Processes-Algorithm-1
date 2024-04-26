function datasetCreate()

param = createConfigFunc(@createDatasetFunc);

run load_func.m

load(param.loadStr);
LG = m.laplacianMat;
x_size = size(m.signal);
numData = param.numData;
trainArray = param.trainArray;

if param.maskType == 4

    av_signal_std = sqrt(mean(m.signal(:).^2));

end

for i = 1 : numData

    saveCell = cell(size(trainArray));
    j = 1;
    for train = trainArray
        valid = train;
        test = 1 - train - valid;

        if param.maskType == 0
            mask = randsrc(x_size(1),x_size(2),[0,1,2;test,train,valid]);
        elseif param.maskType == 1
            mask = zeros(x_size(1),x_size(2));
            testLoc = logical(randsrc(x_size(1),1,[0,1;test,train + valid]));
            for l = 1 : x_size(2)

                mask(testLoc,l) = randi([1,2],sum(testLoc),1);

            end
        elseif param.maskType == 2
            mask = zeros(x_size(1),x_size(2));
            indx = 1:x_size(1);
            for l = 1 : x_size(2)
                anchorPoints = randi(x_size(1),train,1);
                nonNeighbors = [];
                neighborIndicate = logical(sum(abs(LG(:,anchorPoints)),2));

                nonNeighbors = indx(~neighborIndicate);
                mask(nonNeighbors, l) = randi([1,2],length(nonNeighbors),1);
            end
        elseif param.maskType == 3

            mask = randsrc(x_size(1),1,[0,1,2;test,train,valid]);
            mask = repmat(mask,1,x_size(2));

        elseif param.maskType == 4

            mask = ones(x_size(1), x_size(2));
            saveCell{j}.dataStruct.data = m.signal + ...
                av_signal_std * train * randn(x_size(1),x_size(2));
            saveCell{j}.snr = 20 * log10(1/train);

        elseif param.maskType == 5
            
            mask = ones(x_size(1), x_size(2));

                saveCell{j}.dataStruct.data = createRealizations(m.b, ...
                    m.g, m.lambda, m.graphEigenVectors, ...
                    size(m.signal,2), true);

        end


        saveCell{j}.dataStruct.mask = mask;
        saveCell{j}.trainInfo = trainArray;
        j = j + 1;
    end

    save([param.saveStr,'_numData_', ...
        num2str(i),'.mat'], ...
        'saveCell');
end


end

