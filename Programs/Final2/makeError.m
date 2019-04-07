function [RecWord,errorMat]=makeError(CodeWord,epsilon)

[rows,cols]=size(CodeWord);
errorMat=rand(rows,cols)<epsilon;

MultMat=~errorMat;
errorMat=errorMat.*(-1);

RecWord=CodeWord.*MultMat;

end