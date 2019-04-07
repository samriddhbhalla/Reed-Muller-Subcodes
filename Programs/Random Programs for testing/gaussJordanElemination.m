function [a]=gaussJordanElemination(H,B)
a=[H,B];
[m,n]=size(a);  % m=> nos rows , n=> nos cols

% PIVOTING
for j=1:m-1
    for z=j+1:m
        if(a(j,j)==0)
            t=a(j,:);
            a(j,:)=a(z,:);
            a(z,:)=t;
        end
    end
    
    % CONVERT ELEMENTS BELOW MAJOR DIAGONAL ZERO
    if(a(j,j)~=0)
        for i=j+1:m
    %         a(i,:)=a(i,:)-a(j,:)*(a(i,j)/a(j,j)); 
          a(i,:)=mod( a(i,:) + a(j,:)*a(i,j),2);   
        end
    end
end

% CONVERT ELEMENTS ABOVE MAJOR DIAGONAL ZERO
for j=m:-1:2
    for i=j-1:-1:1
%         a(i,:)=a(i,:)- a(j,:)*(a(i,j)/a(j,j));
      a(i,:)=mod(  a(i,:)+ a(j,:)*a(i,j),2);  
    end
end
 

 
end
