function testRm=test(k,m)
%k is the degree of the function %m is the size of the RM Code

if(k==0&&m==0) %0th order case
    testRm=1;
elseif(k==0)    
    testRm=[test(k,m-1) test(k,m-1)];
end

if(k==1&&m==1) %1st order case
    testRm=[1,1;0,1];
elseif(k==1)
    testRm=[test(k,m-1),test(k,m-1);ZeroMatrix(1,m-1),test(k-1,m-1)];
end

if(k==m&&k>1&&m>1)
    temp=test(k-1,m-1);
    testRm=[temp,temp;zeroMatrix3(k-1,m-1),temp];
end
if(k>1&&m>1&&m~=k)
    testRm=[test(k,m-1),test(k,m-1);test(1,m-1)*0,test(k-1,m-1)];
end
%%if we only need cases of m==k get another algo;


       