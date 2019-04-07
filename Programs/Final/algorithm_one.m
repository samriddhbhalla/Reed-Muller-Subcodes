%here var(R) is given for the sake of simplicity. It is the defined by the
%following summation r=min{ k: (summation of i=0 to k OF mchoosei ) >=K &&  0<= k<= m}
%
function algo_1=algorithm_one(G,K,R,M)

gCopy=G;
p=getWtOfEachRow(G,M,M);

maxWt=2.^M;
count=1;
counter=count;
index=1;%for the matrix G
idx=1;%for the matrix gCopy

while(idx<K)
    if(p(index)==maxWt)
       gCopy(idx, :)= G(index, :);
       counter=counter-1;
       idx=idx+1;
    end
    index=index+1;
    if(counter==0)
       counter=nchoosek(M,count);
       count=count+1;
       index=1;
       maxWt=maxWt/2;
    end
    
end

algo_1=gCopy;
end
% % 
% % p=getWtOfEachRow(G,M,M);
% % q=ones(2,M+1);
% % for idx=2:M+1
% %     q(1, idx)=q(1,idx-1)+nchoosek(M,idx-2);
% %     q(2, idx)=idx;  
% % end
% % algo_1=q;
% % end