function dim=calcDim(r,m)
dim=0;
for i=0:r
    dim=dim+nchoosek(m,i);
end
