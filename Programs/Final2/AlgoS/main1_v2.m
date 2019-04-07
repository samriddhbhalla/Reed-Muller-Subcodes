%here var(R) is given for the sake of simplicity. It is the defined by the
%following summation r=min{ k: (summation of i=0 to k OF mchoosei ) >=K &&  0<= k<= m}
%
function [algo_1,y]=main1_v2(K,R,M)

gSorted=reedmullergen(R,M);

algo_1=gSorted(1:K, :);
y=1:K;
end
