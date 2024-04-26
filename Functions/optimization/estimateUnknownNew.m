function [re_data, err] = estimateUnknownNew(data, x_local, Rx_found, ...
    mask, vort)
%ESTIMATEUNKNOWNNEW Summary of this function goes here
%   Detailed explanation goes here

if vort

    cond_m1 = (mask == 1);
    cond_m0 = (mask == 2);

else

    cond_m1 = (mask == 1) | (mask == 2);
    cond_m0 = (mask == 0);

end

re_data = zeros(size(x_local));

for m = 1 : size(x_local,2)

    cond1 = cond_m1(:,m);
    cond0 = cond_m0(:,m);
    re_data(cond0,m) = Rx_found(cond0,cond1) * ...
        pinv(Rx_found(cond1,cond1)) * data(cond1,m);
    re_data(~cond0,m) = data(~cond0,m);

end


differ = abs(x_local(cond_m0)-re_data(cond_m0));

err = struct();

err.rnmse=norm(differ)/norm(x_local(cond_m0));
err.rmse = sqrt(mean(differ.^2));
err.mae = mean(differ);
err.mape = mean(differ./abs(x_local(cond_m0)));
err.differ = differ;

end

