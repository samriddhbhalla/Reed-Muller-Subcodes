function zm2=ZeroMatrix2(k,m)% gererates a zero matrix 1 X (2^m) size

if(k==1)
    zm2=ZeroMatrix(k,m);
end
if(k==-1)
    zm2=ZeroMatrix(k,m);
    zm2(1,2^m)=[1];
    %zm2(2.^m,:)=1;
end