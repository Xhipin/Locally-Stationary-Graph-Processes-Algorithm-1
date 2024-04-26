function total_cost = joint_cost(B, Gamma, N, Q, Cl, L, Rx)
%JOINT_COST Summary of this function goes here
%   Detailed explanation goes here

hh = zeros(N);

for k = 1:Cl
   for l = 1:Cl
       temp_B = B((k-1)*Q + 1 : k*Q, (l-1)*Q + 1 : l*Q);
       temp_B = temp_B(:);
       temp_B = temp_B';
       temp_Gamma = Gamma((k-1)*N + 1 : k*N, (l-1)*N + 1 : l*N);
       hh = hh + temp_Gamma .* (kron(temp_B,eye(N))*L);
       
   end
end
total_cost = Rx - hh;
total_cost = total_cost(:);
total_cost = sum_square_abs(total_cost);
end

