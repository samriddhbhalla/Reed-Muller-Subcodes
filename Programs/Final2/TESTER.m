function [X,PCM,B,RecWord,Erasure,errorMat,EncWord]=TESTER()
% List Structure Var
k=11;
m=4;
n=16;%2^m
r=2;
nosWords=1;
col=k;
epsilon=.25;

% Get Generator Matrix and its dual code
[G1,~]=main1_v2(k,r,m);
[PCM,~]=main1_v2(2.^m-k,m-r-1,m);
% Get the word and corrupt it
[EncWord,~]=wordGenerator_v3(nosWords,col,G1);
[RecWord,errorMat]=makeError(EncWord,epsilon);
% Get Erasure Vector and chill
Erasure=-errorMat;
B=mod(PCM*(RecWord).',2);

w=sum(Erasure);
index=zeros(1,w);
indexSize=0;%should be equal to sum(erasure) cool Right;

for idx=n:-1:1
    if(Erasure(idx)==0)         
        PCM(:,idx)=[];
%         COunt and note no of Erasures;
    else        
        index(w-indexSize)=idx;
        indexSize=indexSize+1;
    end
end

% convert to Galois field
PCM=gf(PCM,1);
B=gf(B,1);
X=PCM\B

for idx=1:indexSize
    if(X(idx)==0)
    Erasure(index(idx))=0;
    end
end

end

%%UTILITY FUNCTION 
% reedmullergen





%main1_v2
function [algo_1,y]=main1_v2(K,R,M)

gSorted=reedmullergen(R,M);

algo_1=gSorted(1:K, :);
y=1:K;
end

%WordGenerator_v3
function [EncWord,BinWord]=wordGenerator_v3(nos,col,G)%,R,M)
% nos is number of words max is maximum number-1 and col is number of bits[
% G=reedmullergen(R,M);
EncWord=rand(nos,col);
BinWord=(EncWord>.5);
EncWord=mod(BinWord*G,2);
end

% makeError
function [RecWord,errorMat]=makeError(CodeWord,epsilon)
[rows,cols]=size(CodeWord);
errorMat=rand(rows,cols)<epsilon;
MultMat=~errorMat;
errorMat=errorMat.*(-1);
RecWord=CodeWord.*MultMat ;%+ errorMat; 


% [rows,cols]=size(CodeWord);  
% MultMat1=rand(rows,cols)>epsilon;
% MultMat2=~MultMat1;
% RecWord=CodeWord.*MultMat1;
% MultMat2=MultMat2.*(rand(rows,cols)>0.5);
% RecWord=RecWord+MultMat2;
end

% word comparator
% function nosErrors = compareWords2(word1,word2)
%    diffMatrix=mod(word1+word2,2);
%    nosErrors=sum(diffMatrix,2);
% end
