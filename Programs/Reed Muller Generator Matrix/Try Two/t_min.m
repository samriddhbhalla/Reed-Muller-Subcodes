function tmin=t_min(k,m)

sumOfBinomial=0;
r=0;
while(r<=m&&sumOfBinomial<k)
   sumOfBinomial=sumOfBinomial+nchoosek(m,r);
   r=r+1;
end
tmin=r;