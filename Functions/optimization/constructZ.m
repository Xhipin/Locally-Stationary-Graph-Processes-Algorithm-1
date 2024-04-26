function Z = constructZ(N,Cl)

Z = eye(N*Cl);
Z = reshape(Z,N*Cl,N,Cl);
tempZ = zeros(N,N*Cl,Cl);
for i = 1:Cl
    tempZ(:,:,i) = Z(:,:,i)';
end
Z = tempZ;

end
