function [PCM,EncWord1,ErasureVector,ECode,RecWord]=TESTERFAIL()
%%Test Parameter
k=11;
col=k;
r=2;
m=4;
epsilon=.25;
nosWords=1;
%%Start with the case of k is sum of binoomial and do with PCM hell yeah!!!

%Generate matrices
[G1,y1]=main1_v2(k,r,m);


[EncWord1,BinWord1]=wordGenerator_v3(nosWords,col,G1);
 [RecWord]=makeError(EncWord1,epsilon);

% x=RecWord.';
ErasureVector=RecWord<0;
z=sum(ErasureVector)
[PCM,PCMy1]=main1_v2(16-k,m-r-1,m);
% Zeros=PCM*EncWord1.'
% Zeros=PCM*x
RecWord=RecWord+ErasureVector;
% x=mod(PCM*RecWord.',2)
x=PCM*RecWord.'
x=mod(PCM*RecWord.',2);
PCM=PCM.*repmat(ErasureVector,16-k,1);
ErasureCode=mod(PCM\x,2);
ECode=(ErasureCode>0.5)&(ErasureCode<1.5);
ECode=ECode.';
RecWord=RecWord+ECode;

nosErrors = compareWords2(RecWord,EncWord1)
end

%%UTILITY FUNCTION 
% reedmullergen

function G = reedmullergen(R, M)

  G = ones (1, 2^M);
  if (R == 0)
    return;
  end

  a = [0];
  b = [1];
  V = [];
  for i = 1:M;
    row = repmat ([a, b], [1, 2^(M-i)]);
    V(i,:) = row;
    a = [a, a];
    b = [b, b];
  end

  G = [G; V];

  if (R == 1)
    return;
  else
    r = 2;
    while (r <= R)
      p = nchoosek (1:M, r);
      temp = V(p(:,1),:) .* V(p(:,2),:);
      for i = 3:r
        temp = temp .* V(p(:,i),:);
      end
      G = [G; temp];
      r = r + 1;
    end
  end

end

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
function [RecWord]=makeError(CodeWord,epsilon)
[rows,cols]=size(CodeWord);
errorMat=rand(rows,cols)<epsilon;
MultMat=~errorMat;
errorMat=errorMat.*(-1);
RecWord=CodeWord.*MultMat + errorMat; 


% [rows,cols]=size(CodeWord);  
% MultMat1=rand(rows,cols)>epsilon;
% MultMat2=~MultMat1;
% RecWord=CodeWord.*MultMat1;
% MultMat2=MultMat2.*(rand(rows,cols)>0.5);
% RecWord=RecWord+MultMat2;
end

% word comparator
function nosErrors = compareWords2(word1,word2)
   diffMatrix=mod(word1+word2,2);
   nosErrors=sum(diffMatrix,2);
end
