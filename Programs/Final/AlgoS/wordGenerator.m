function [EncWord,DecWord,BinWord]=wordGenerator(nos,max,col,R,M)
G=reedmullergen(R,M);
for idx=1:nos
    DecWord(idx)=260;%floor(rand()*max);
    BinWord(idx, :)=de2bi(DecWord(idx),col,'left-msb');
    EncWord(idx, :)=mod(BinWord(idx, :)*G,2);
end
end