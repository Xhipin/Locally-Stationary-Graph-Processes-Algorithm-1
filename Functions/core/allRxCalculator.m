function [Rx, n_Rx] = allRxCalculator(data, mask, covType)

if covType == 0
    data(mask == 0) = NaN;
    Rx = cell2mat(rxestimator(data,0));
elseif covType == 1
    data(mask == 0) = 0;
    data = diffuseker(data,0.8,LG,mask);
    Rx = cell2mat(rxestimator(data,0));
elseif covType == 2
    data(mask == 0) = NaN;
    Rx = cell2mat(rxestimator(data,0));
    Rx = refinecovariance(Rx,0.01);
elseif covType == 3
    data(mask == 0) = NaN;
    interpData = linearInterpolation(data, W, 2);
    Rx = cell2mat(rxestimator(interpData,0));
elseif covType == 4
    Rx = cov(data.', "partialrows");
end
Rx(isnan(Rx)) = 0;
n_Rx = norm(Rx);
Rx = Rx/n_Rx;

end