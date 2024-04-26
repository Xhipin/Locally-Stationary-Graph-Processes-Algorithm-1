function newdata=diffuseker(data,alpha,LG,mask)
%%
% Purpose of this function is to have a smooth data representation for
% given missing values on graph represented by LG.

%% Input
% LG: NxN graph Laplacian
% data: should be a NxM matrix where M is the length of the data
% alpha: coefficient governing the diffusion
% MIS: Mx1 cell containing matrices denoting the place of missing values at
% each column

%% NOTE: missing values in data are 0 in this function.

%% Output
% newdata: NxM matrix where missing values are replaced by the result of
% the diffusion kernel.

d_size= size(data);
if length(d_size)<3
    d_size(3) = 1;
end
D= diag(diag(LG));
W= D-LG;
S= D^(-0.5)*W*D^(-0.5);

newdata=data;

data= reshape(data, d_size(1), d_size(2)*d_size(3));
temp= (1-alpha)*(eye(d_size(1))-alpha*S)^(-1)*data;
temp= reshape(temp, d_size(1), d_size(2), d_size(3));

newdata(mask==0)= temp(mask==0);

end
