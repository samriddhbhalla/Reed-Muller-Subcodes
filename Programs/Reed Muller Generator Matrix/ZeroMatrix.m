function zm=ZeroMatrix(k,m)% gererates a zero matrix 1 X (2^m) size

if(k==1)
    
    if(m==0) %0th order case
        zm=0;
    elseif(m~=0)    
        zm=[ZeroMatrix(k,m-1) ZeroMatrix(k,m-1)];
    end
end
if(k==-1)
    if(m==0) %0th order case
        zm=0;
    elseif(m~=0)    
        zm=[ZeroMatrix(k,m-1) ZeroMatrix(k,m-1)];
    end
end