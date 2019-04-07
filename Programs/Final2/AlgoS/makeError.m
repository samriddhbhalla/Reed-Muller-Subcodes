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