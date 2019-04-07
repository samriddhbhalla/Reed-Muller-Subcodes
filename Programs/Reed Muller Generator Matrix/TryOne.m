function rm=TryOne(k,m)
%k is the degree of the function %m is the size of the RM Code

if(k==0&&m==0) %0th order case
    rm=1;
elseif(k==0)    
    rm=[TryOne(k,m-1) TryOne(k,m-1)];
end

if(k==1&&m==1) %1st order case
    rm=[1,1;0,1];
elseif(k==1)
    rm=[TryOne(k,m-1),TryOne(k,m-1);ZeroMatrix(1,m-1),TryOne(k-1,m-1)];
end

if(k==m&&k>1&&m>1)
    rm=[TryOne(k-1,m);ZeroMatrix2(-1,m)];
end
if(k>1&&m>1&&m~=k)
    rm=[TryOne(k,m-1),TryOne(k,m-1);TryOne(k-1,m-1)*0,TryOne(k-1,m-1)];
end
%%if we only need cases of m==k get another algo;


       