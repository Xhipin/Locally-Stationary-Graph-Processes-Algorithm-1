function rx = rxestimator(data,P)
%% rxestimator
% Covariance matrix estimator handling the missing data

%% Input
% data: Training N-dim vector time series data for covariance matrix estimation.
% Missing values are labeled as NaN. (NxT array)
% P: max number of time lags. The function will return covariance estimates
% for time lags from 0 to P.

%% Output
% rx: (P+1)x1 cell containing covariance matrices for each time lag.

%% Code

rx=cell(P+1,1);
T=size(data);

% T=T(2);

for i=0:P
    temp=zeros(T(1));
    frist=data(:,1:end-i);
    lats=data(:,1+i:end);
    
    for k=1:T(1)
        for l=1:T(1)
            
            A=frist(k,:).*lats(l,:);
            A(isnan(A))=[];
            temp(k,l)=mean(A);
            
        end
    end
    
    rx{i+1}=temp;
    
end
end

