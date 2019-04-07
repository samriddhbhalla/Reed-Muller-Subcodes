function rmc=TryTwo(r,m)
len = uint64(0);
    % r=0;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(r==0&&m==0)
    rmc=[0;1];
elseif(r==0)
    rmc=[TryTwo(0,m-1),TryTwo(0,m-1)];    
    %r=1;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(r==1&&m==1);
    rmc=[0 0;0 1;1 0;1 1];
elseif(r==1)
    rmc=[TryTwo(1,m-1),TryTwo(1,m-1);TryTwo(1,m-1),~TryTwo(1,m-1)];
    %r=m case %%%%%%%%%%%%%%%%%%%%%%%%%%
elseif(r==m && r>1)
    %declare rmc later
    for i=0:(2.^(2*m)) -1
       rmc(i+1,:)=de2bi(i,2*m,'left-msb'); 
    end
    %rest of the cases %%%%%%%%%%%%%%%%%
else
    dim1=calcDim(r,m-1);
    dim2=calcDim(r-1,m-1);
    temp1=TryTwo(r,m-1);
    temp2=TryTwo(r-1,m-1);
    rmc=[];
    for j=1:2.^dim2
        for i=1:2.^dim1
            rmc=[rmc;temp1(i,:),xor(temp1(i,:),temp2(j,:))];
        end
    end
end