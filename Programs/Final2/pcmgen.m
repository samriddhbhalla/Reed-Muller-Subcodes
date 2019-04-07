function [PCM,PCMy]=pcmgen(k,r,m,y)
% the ys are to be removed
sum=0;
n=2.^m;
for idx=0:r
    sum=sum+nchoosek(m,idx);
end
y=sort(y);
if(sum==k)
    %k is a sum of binomial 
    PCM=reedmullergen(r,m);
    PCMy=1:k;
else
    PCM=reedmullergen(r+1,m);
    PCMy=1:(sum+nchoosek(m,r+1));
    
    yStartIndex=n-sum-nchoosek(m,r+1);
    y0=y(yStartIndex+1);
    PCM=[PCMy.',PCM];
    for idx=1:nchoosek(m,r+1)-(k-sum)
        PCM( sum + nchoosek(m,r+1) - y(yStartIndex+idx) + y0 ,:)=[];
    end
    PCMy=(PCM(:,1)).';
    PCM(:,1)=[];
end    
end