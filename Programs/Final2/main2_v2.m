% Randomly selecting s rows out of nchoosek(M,T) min wt rows

function [algo_2,y]=main2_v2(K,R,M) %also return the indexes to be used

g2=reedmullergen(R,M);

sum=0;
for idx=0:M
    sum=sum+nchoosek(M,idx);
    if(sum>K)
        break;
    end
end
s=sum-K;
rowsToBeKept=nchoosek(M,idx)-s;% this gives the number of rows to be kept;

y=sort(datasample(1:nchoosek(M,idx),rowsToBeKept,'Replace',false));
sum=sum-nchoosek(M,idx);
% g2(sum,:);

% algo_2=0;
Gextra=g2(sum+y, :);
y=sum+y;
y=[1:sum,y];
algo_2=[g2(1:sum,:);Gextra];
end