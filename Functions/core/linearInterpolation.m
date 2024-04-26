function interp = linearInterpolation(data, W, maxNeigh)
%LINEARINTERPOLATION Summary of this function goes here
%   Detailed explanation goes here

interp = zeros(size(data));

for i = 1 : size(data,1)
    for j = 1 : size(data,2)
        if ~isnan(data(i,j))
            interp(i,j) = data(i,j);
            continue;
        end
        currW = W;
        meanCalculated = false;

        for numNeigh = 1 : maxNeigh
            
            neighs = (currW(i,:) ~= 0);

            if all(isnan(data(neighs,j)))
                currW = currW * W;
                  continue;
            else
                  interp(i,j) = mean(data(neighs,j),"omitnan");
                  meanCalculated = true;
                  break;
            end
            
        end

        if ~meanCalculated
           interp(i,j) = mean(data(:,j),"omitnan");
        end

    end

end


end

