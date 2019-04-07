function [EncWord,DecWord,BinWord]=wordGenerator_v2(nos,max,col,G,R,M)
% nos is number of words max is maximum number-1 and col is number of bits[
% G=reedmullergen(R,M);
for idx=1:nos
    DecWord(idx)=520;%floor(rand()*max);
    BinWord(idx, :)=de2bi(DecWord(idx),col,'left-msb');
    EncWord(idx, :)=(BinWord(idx, :)*G);
end
end