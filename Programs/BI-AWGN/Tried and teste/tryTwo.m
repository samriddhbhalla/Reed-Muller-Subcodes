function [CheckForError,ARR,ARR2]=tryTwo()% Failed cuz i need to remove the non independent row 
k=              128;
r=              4; 
m=              8;
n=              2.^m;
col=            k; 
nosWords=       1;
snr=            05;

% define generator matrix
G=main3(k,r,m);
% get encoded word
[EncWord,~,~,~]=wordGenerator_v4(nosWords,col,G,G,G);
% make a noisy word
RecWord=awgn(EncWord*2-1,snr);

%% Confidence values and detected word via threshold detection:
% HARD DECISION
HardDecision=   RecWord>0;
Confidence=     abs(RecWord);
y=              1:n; %Permutation Vector 1
y2=             1:n;
index_y2_2=     k+1;

% SOFT DECISION - ORDER 0
ARR=            [Confidence;HardDecision;EncWord;RecWord;G;y].';
ARR=            sortrows(ARR,-1);
ARR=            ARR.';
S_Confidence=   ARR(1,:);
S_HardDecision= ARR(2,:);
S_EncWord=      ARR(3,:);
S_RecWord=      ARR(4,:);
S_G=            ARR(5:(end-1),:);
y1=             ARR(end,:); % ORIGNAL PERMUTATION

% Selection of K INDEPENDENT columns of MAXIMUM confidence
CurrentRowNumber=1;
for CurrentColumnNumber=1:n
    CurrentColumn=S_G(:,CurrentColumnNumber);
    if CurrentColumn(CurrentRowNumber)==0
        y2(CurrentColumnNumber)=index_y2_2;
        index_y2_2=index_y2_2+1;
        continue;
    end
    y2(CurrentColumnNumber)=CurrentRowNumber;
    
%     forward elemination
    for idx=(CurrentRowNumber+1):k
        S_G(idx,:)=mod(S_G(idx,:)+S_G(CurrentRowNumber,:).*S_G(idx,CurrentColumnNumber),2);
    end
    
%     Back Elemination
    for idx=1:(CurrentRowNumber-1)
        S_G(idx,:)=mod(S_G(idx,:)+S_G(CurrentRowNumber,:).*S_G(idx,CurrentColumnNumber),2);
    end
    
    CurrentRowNumber=CurrentRowNumber+1;
    if(CurrentRowNumber==k+1)
        break;
    end        
end

% getting it in systemic form
ARR2=[y2;S_HardDecision;S_EncWord;S_RecWord;S_G;y1].';
ARR2=sortrows(ARR2,1);
ARR2=ARR2.';
S_HardDecision= ARR2(2,:);
S_EncWord=      ARR2(3,:);
S_RecWord=      ARR2(4,:);
S_G=            ARR2(5:(end-1),:);
y1=             ARR2(end,:);

% So now We choose the k MRBs
ConfidentBits=S_HardDecision(1:k);
ReEncodedWord=ConfidentBits*S_G;

CheckForError=mod(EncWord+ReEncodedWord,2);

end
