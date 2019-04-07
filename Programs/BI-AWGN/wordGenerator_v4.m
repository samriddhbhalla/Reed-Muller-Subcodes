function [EncWord1,EncWord2,EncWord3,BinWord]=wordGenerator_v4(nos,col,G1,G2,G3)

BinWord=rand(nos,col);
BinWord=(BinWord>.5);
EncWord1=mod(BinWord*G1,2);
EncWord2=mod(BinWord*G2,2);
EncWord3=mod(BinWord*G3,2);
end