function [errorVec]=ErrorPatternGenerator(k,order) % this will support order 2;

nck=nchoosek(k,order);
errorVec=zeros(nck,k);
q=1:k;
chooseVec=nchoosek(q,order);
for idx=1:nck
   errorVec(idx,chooseVec(idx,:))=1; 
end
     
end