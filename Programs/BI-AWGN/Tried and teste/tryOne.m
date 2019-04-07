function [ARR,ERR]=tryOne()
% Define parameters
k=11;
r=2;
m=4;
col=k;
nosWords=1;
snr=0.05;

% define generator matrix
G=reedmullergen(r,m);
% get encoded word
[EncWord,~,~,~]=wordGenerator_v4(nosWords,col,G,G,G);
% make some noise for the boys

% make a noisy word
RecWord=awgn(EncWord*2-1,snr);

%% DECISION

HardDecision=RecWord>0;
Confidence=abs(RecWord);
ARR=[Confidence;HardDecision;EncWord;RecWord];
% Sort The HardDecVec according to Confidence Values
HardDecision2=[Confidence;HardDecision;EncWord].';
HardDecision2=sortrows(HardDecision2,-1);
HardDecision2=HardDecision2.';
HardDecision2(1,:)=[];
EncWordSorted=HardDecision2(2,:);
HardDecision2(2,:)=[];
% Sort The Generator matrix according to Confidence Values
G2=[Confidence;G];
G2=G2.';
G2=sortrows(G2,-1);
G2=G2.';
G2(1,:)=[];
% Sort Confidence
% Confidence=sort(Confidence,'descend');
G2=GJE2(G2,[]);
% %%
 NosErrors=mod(HardDecision+EncWord,2);
%% ORDER 0
ConfidentBits=HardDecision2(1:k); %Consider these to be orignal word and reencode
ReEncWord=ConfidentBits*G2;
NosErrors2=mod(ReEncWord+EncWordSorted,2);
ERR=[EncWordSorted;ReEncWord;NosErrors;NosErrors2];
end

