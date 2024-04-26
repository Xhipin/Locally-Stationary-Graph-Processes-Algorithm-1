function L = constructL(N,Q,LG)

L = zeros(N,N,Q);

for q = 0 : Q-1
    
    L(:,:,q+1) = LG^(Q-1-q);
end

L = reshape(L, N,N*Q);
L = L' * L;
temp_L = zeros(N*Q^2,N);
for i = 1 : Q
    temp_L((i-1)*N*Q + 1 : i*N*Q,:) = L(:,(i-1)*N + 1: i*N);
end

L = temp_L;

end