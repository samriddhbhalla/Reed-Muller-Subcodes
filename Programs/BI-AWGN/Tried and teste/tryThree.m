function [WER1,WER2]=tryThree()% Failed cuz i need to remove the non independent row
k=              128;
r=              4;
m=              8;
n=              2^m;
col=            k;
nosWords=       1000;
% snr=            03;
TotalWords=     0;
TotalError1=    0;
TotalError2=    0;
% define generator matrix
G=main3(k,r,m);
% get encoded word
[EncWordArr,~,~,~]=wordGenerator_v4(nosWords,col,G,G,G);
% make a noisy word
h=comm.AWGNChannel('EbNo',2.5);
RecWordArr=step(h,EncWordArr*2-1);
% RecWordArr=awgn(EncWordArr*2-1,snr);
% check for 100 words; nchoosek
while TotalError2<100 && TotalWords<100000
    for idy=1:nosWords
        EncWord=        EncWordArr(idy,:);
        RecWord=        RecWordArr(idy,:);
        %% Confidence values and detected word via threshold detection:
        % HARD DECISION
        HardDecision=   RecWord>0;
        Err2=sum(mod(EncWord+HardDecision,2));
        TotalError1=TotalError1+(Err2>0);
        Confidence=     abs(RecWord);
        y=              1:n; %Permutation Vector 1
        % y2=             1:n;
        index_y2_1=     1;
        % index_y2_2=     k+1;
        
        % SOFT DECISION - ORDER 0
        ARR=            [Confidence;HardDecision;EncWord;RecWord;G;y].';
        ARR=            sortrows(ARR,-1);
        ARR=            ARR.';
        %     S_Confidence=   ARR(1,:);
        S_HardDecision= ARR(2,:);
        S_EncWord=      ARR(3,:);
%              S_RecWord=      ARR(4,:);
        S_G=            ARR(5:(end-1),:);
        y1=             ARR(end,:); % ORIGNAL PERMUTATION
        
        % Selection of K INDEPENDENT columns of MAXIMUM confidence
        CurrentRowNumber=1;
        Gtemp=[];
        y2=1:n;
        S_G=[S_G;y2;S_EncWord;S_HardDecision;y1];
        while CurrentRowNumber<=k
            CurrentColumn=S_G(:,index_y2_1);
            index_y2_1=index_y2_1+1;
            if CurrentColumn(CurrentRowNumber)==0
                Gtemp=[Gtemp,CurrentColumn];
                continue;
            end
            if size(Gtemp,2)~=0
                S_G(:,CurrentRowNumber)=CurrentColumn;
                S_G(:,CurrentRowNumber+1:index_y2_1-1)=Gtemp;
                index_y2_1=CurrentRowNumber+1;
                Gtemp=[];
            else
                index_y2_1=CurrentRowNumber+1;
            end
            %     forward elemination
            for idx=(CurrentRowNumber+1):k
                S_G(idx,:)=mod(S_G(idx,:)+S_G(CurrentRowNumber,:).*S_G(idx,CurrentRowNumber),2);
            end
            
            %     Back Elemination
            for idx=1:(CurrentRowNumber-1)
                S_G(idx,:)=mod(S_G(idx,:)+S_G(CurrentRowNumber,:).*S_G(idx,CurrentRowNumber),2);
            end
            CurrentRowNumber=CurrentRowNumber+1;
        end
        S_G2=           S_G(1:k,:);
        %     y2=             S_G(k+1,:);
        S_EncWord=      S_G(k+2,:);
        S_HardDecision= S_G(k+3,:);
        %     y1=             S_G(k+4,:);
        
        ConfidenceBits=S_HardDecision(1:k);
        Re_EncWord=mod(ConfidenceBits*S_G2,2);
        
        ErrorMat=sum(mod(Re_EncWord+S_EncWord,2));
        TotalError2=TotalError2+(ErrorMat>0);
        
    end
    TotalWords=TotalWords+nosWords
end
WER1=TotalError1/TotalWords;
WER2=TotalError2/TotalWords;

end
