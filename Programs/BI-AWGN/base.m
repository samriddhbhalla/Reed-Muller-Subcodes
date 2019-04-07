function [WORDSARR,ERRORARR]=base()
k=              128;
r=              4;
m=              8;
n=              2^m;
col=            k;
nosWords=       100;
G1=             main1_v2(k,r,m);
G2=             main2_v2(k,r,m);
G3=             main3(k,r,m);
WORDSARR=      [];
BER=[];
ERRORARR=      [];
for snr=1:0.5:2.5
    TotalWords=     [0 0 0];
    TotalError2=    [0 0 0];
    while TotalError2(1)<100 || TotalError2(3)<100 ||TotalError2(2)<100
        [EncWordArr1,EncWordArr2,EncWordArr3,~]=wordGenerator_v4(nosWords,col,G1,G2,G3);
        for outer=1:3
            
            if outer==1
                if TotalError2(outer)>100
                    continue;
                end
                TotalWords(outer)=  TotalWords(outer)+1;
                EncWordArr=         EncWordArr1;
                G=G1;
            elseif outer == 2
                if TotalError2(outer)>100
                    continue;
                end
                TotalWords(outer)=  TotalWords(outer)+1;
                EncWordArr=         EncWordArr2;
                G=G2;
            else
                if TotalError2(outer)>100
                    continue;
                end
                TotalWords(outer)=  TotalWords(outer)+1;
                EncWordArr=         EncWordArr3;
                G=G3;
            end
            
            h=comm.AWGNChannel('EbNo',snr);
            RecWordArr=      step(h,EncWordArr*2-1);
            for idy=1:nosWords
                EncWord=        EncWordArr(idy,:);
                RecWord=        RecWordArr(idy,:);
                HardDecision=   RecWord>0;
                Confidence=     abs(RecWord);
                y=              1:n;                  
                ARR=            [Confidence;HardDecision;EncWord;RecWord;G;y].';
                ARR=            sortrows(ARR,-1);
                ARR=            ARR.';
                S_HardDecision= ARR(2,:);
                S_EncWord=      ARR(3,:);
                S_RecWord=      ARR(4,:);
                S_G=            ARR(5:(end-1),:);
                y1=             ARR(end,:);                
                CurrentRowNumber=1;
                GIndep=          [];
                GDep=            [];
                y2=             1:n;
                S_G=            [S_G;y2;S_EncWord;S_HardDecision;y1;S_RecWord];
                while CurrentRowNumber<=k
                    CurrentColumn=  S_G(:,CurrentRowNumber);
                    if(CurrentColumn(CurrentRowNumber)~=1)
                        if(CurrentColumn(CurrentRowNumber:k)==0)%not independent SO SEND IT TO THE END
                            S_G=[S_G,CurrentColumn];
                            S_G(:,CurrentRowNumber)=[];
                            continue;
                        else
                            loc=CurrentRowNumber+find(CurrentColumn(CurrentRowNumber+1:k),1);
                            tempRow=S_G(CurrentRowNumber,:);
                            S_G(CurrentRowNumber,:)=S_G(loc,:);
                            S_G(loc,:)=tempRow;
                        end
                    end
                    for idx=(CurrentRowNumber+1):k
                        S_G(idx,:)=mod(S_G(idx,:)+S_G(CurrentRowNumber,:).*S_G(idx,CurrentRowNumber),2);
                    end
                    
                    for idx=1:(CurrentRowNumber-1)
                        S_G(idx,:)=mod(S_G(idx,:)+S_G(CurrentRowNumber,:).*S_G(idx,CurrentRowNumber),2);
                    end
                    CurrentRowNumber=CurrentRowNumber+1;
                end
                S_G2=           S_G(1:k,:);
                S_EncWord=      S_G(k+2,:);
                S_HardDecision= S_G(k+3,:);
                S_RecWord=      S_G(k+5,:);
%                 S_RecWordONE=   abs(S_RecWord-1);
%                 S_RecWordZERO=  abs(S_RecWord+1);
%                 S_RecWord2=[S_RecWordZERO;S_RecWordONE];for now
                ConfidenceBits=S_HardDecision(1:k);
                Re_EncWord=mod(ConfidenceBits*S_G2,2);
                ReqWord=Re_EncWord;
                Re_EncWord=2*Re_EncWord-1;
                MinDist=sum(abs(S_RecWord-Re_EncWord));
                %% ORDER 1
                errorVecOrder1=ErrorPatternGenerator(k,1);
                for idx = 1:k
                   EncWordErrOrder1= mod(errorVecOrder1(idx,:)+ConfidenceBits,2);
                   EncWordErrOrder1c=mod(EncWordErrOrder1*S_G2,2);
                   EncWordErrOrder1=2*EncWordErrOrder1c-1;
                   TempDist=sum(abs(S_RecWord-EncWordErrOrder1));
                   if(MinDist>TempDist)
                        ReqWord=EncWordErrOrder1c;
                        MinDist=TempDist;
                   end    
                end
                %% ORDER 2
%                 errorVecOrder1=ErrorPatternGenerator(k,2);
%                 for idx = 1:nchoosek(k,2)
%                    EncWordErrOrder1= mod(errorVecOrder1(idx,:)+ConfidenceBits,2);
%                    EncWordErrOrder1c=mod(EncWordErrOrder1*S_G2,2);
%                    EncWordErrOrder1=2*EncWordErrOrder1c-1;
%                    TempDist=sum(abs(S_RecWord-EncWordErrOrder1));
%                    if(MinDist>TempDist)
%                         ReqWord=EncWordErrOrder1c;
%                         MinDist=TempDist;
%                    end    
%                 end
%                 Re_EncWord=mod(ConfidenceBits*S_G2,2);
                ErrorMat=sum(mod(ReqWord+S_EncWord,2));
                TotalError2(outer)=TotalError2(outer)+(ErrorMat>0);
            end            
        end
    end
    WORDSARR=[WORDSARR;snr,TotalWords];
    BER=[BER;snr,(TotalError2./TotalWords)/100]
    ERRORARR=[ERRORARR;snr,TotalError2];%leave this as it is and add other stuff
end
end
