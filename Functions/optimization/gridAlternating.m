function saveStruct = gridAlternating(sym_func, gridParams, extraParams)
saveStruct = struct();

gridNums = gridParams.gridNums;
L = length(gridNums);
if L<3
    conc = gridNums(1)*ones(1,3-L);
    gridNums = [gridNums,conc];

elseif L>3
    gridNums = gridNums(1:3);
end

gridInterval = log10(gridParams.gridInterval);
initialxLocations = getLogGrid(gridInterval, gridNums);
minF = Inf;

[minF, minX, fVector] = gridSearch(sym_func, extraParams, initialxLocations, minF);
gridInterval = zeros(size(gridInterval));
gridInterval(1,:) = [0.5*minX(1),5*minX(1)];
gridInterval(2,:) = [0.5*minX(2),5*minX(2)];
gridInterval(3,:) = [0.5*minX(3),5*minX(3)];

secondaryxLocations = getLinGrid(gridInterval, gridNums);

[minG, minX, gVector] = gridSearch(sym_func, extraParams, secondaryxLocations, minF);

fVector = [fVector;gVector];
allxLocations = [initialxLocations; secondaryxLocations];

saveStruct.f_opt = minG;
saveStruct.x_opt = minX;
saveStruct.fVector = fVector;
saveStruct.xVector = allxLocations;

end

%% Auxilary Functions
function M = getLogGrid(gridInterval, gridNums)

x1 = logspace(gridInterval(1,1),gridInterval(1,2),gridNums(1));
x2 = logspace(gridInterval(2,1),gridInterval(2,2),gridNums(2));
x3 = logspace(gridInterval(3,1),gridInterval(3,2),gridNums(3));

M = cartesianProduct3(x1,x2,x3);

end

function M = getLinGrid(gridInterval, gridNums)

x1 = linspace(gridInterval(1,1),gridInterval(1,2),gridNums(1));
x2 = linspace(gridInterval(2,1),gridInterval(2,2),gridNums(2));
x3 = linspace(gridInterval(3,1),gridInterval(3,2),gridNums(3));

M = cartesianProduct3(x1,x2,x3);

end

function M = cartesianProduct3(x1,x2,x3)
L2 = length(x2)*length(x3);
L1 = length(x1);
M = zeros(L1*L2,3);

[x2mesh,x3mesh] = meshgrid(x2,x3);
mesh23 = [x2mesh(:),x3mesh(:)];

for i= 1 : L1
    for j = 1 : L2
        M((i-1)*L2 + j, :) = [x1(i), mesh23(j,:)];
    end
end
end

function [minF, minX, fVector] = gridSearch(sym_func, extraParams, initialxLocations, minF)

sLoc = size(initialxLocations);

fVector = zeros(sLoc(1),1);
minX = zeros(sLoc(2),1);
for i = 1:sLoc(1)

    currX = initialxLocations(i,:);
    extraParams.mu_two = currX(1);
    extraParams.mu_three = currX(2);
    extraParams.mu_four = currX(3);

    fVector(i) = sym_func(extraParams);

    if minF>fVector(i)
        minF = fVector(i);
        minX = initialxLocations(i,:);
    end
end

end