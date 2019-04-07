function kro=kronekerMfold(mat,m)

if(m~=1)
kro=kronekerMfold([mat,0*mat;mat mat],m-1);
else
    kro=mat;
end

