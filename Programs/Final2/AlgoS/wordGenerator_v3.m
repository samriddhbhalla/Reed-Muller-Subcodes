function [EncWord,BinWord]=wordGenerator_v3(nos,col,G)%,R,M)
% nos is number of words max is maximum number-1 and col is number of bits[
% G=reedmullergen(R,M);
EncWord=rand(nos,col);
BinWord=(EncWord>.5);
EncWord=mod(BinWord*G,2);
end
% function [EncWord,DecWord,BinWord]=wordGenerator_v2(nos,max,col,G)%,R,M)
% % nos is number of words max is maximum number-1 and col is number of bits[
% % G=reedmullergen(R,M);
% DecWord=zeros(1,nos);
% BinWord=zeros(nos,col);
% [~,col2]=size(G);
% EncWord=zeros(nos,col2);
% for idx=1:nos
%     DecWord(idx)=floor(rand()*(2.^(max-mod(idx,max))));
%     BinWord(idx, :)=de2bi(DecWord(idx),col,'left-msb');
%     EncWord(idx, :)=mod((BinWord(idx, :)*G),2);
% end
% end