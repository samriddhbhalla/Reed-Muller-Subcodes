function [WORDSARR,ERRORARR,BERARR]=test1()% Failed cuz i need to remove the non independent row
k=              42;
r=              3;
m=              6;
n=              2^m;
col=            k;
nosWords=       100;
% snr=            03;

% define generator matrix 0
G1=             main1_v2(k,r,m);
G2=             main2_v2(k,r,m);
G3=             main3(k,r,m);

% get encoded word
% [EncWordArr1,EncWordArr2,EncWordArr3,~]=wordGenerator_v4(nosWords,col,G1,G2,G3);
% make a noisy word

WORDSARR=      [];
ERRORARR=      [];
BERARR=[];
for snr=1:0.5:5
    TotalWords=     [0 0 0];
%     TotalError1=    [0 0 0];
    TotalError2=    [0 0 0];
    % check for 100 words;
    while TotalError2(1)<100 
        [EncWordArr1,EncWordArr2,EncWordArr3,~]=wordGenerator_v4(nosWords,col,G1,G2,G3);
        for outer=1:1
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
                TotalWords(outer)=  TotalWords(outer)+nosWords;
                EncWordArr=         EncWordArr2;
                G=G2;
            else
                if TotalError2(outer)>100
                    continue;
                end
                TotalWords(outer)=  TotalWords(outer)+nosWords;
                EncWordArr=         EncWordArr3;
                G=G3;
            end
            h=comm.AWGNChannel('EbNo',snr);
            RecWordArr=      step(h,EncWordArr*2-1);
            for idy=1:nosWords
                EncWord=        EncWordArr(idy,:);
                RecWord=        RecWordArr(idy,:);
                %% Confidence values and detected word via threshold detection:
                % HARD DECISION
                HardDecision=   RecWord>0;
%                 Err2=           sum(mod(EncWord+HardDecision,2));
%                 TotalError1=    TotalError1+(Err2>0);
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
                %     S_RecWord=      ARR(4,:);
                S_G=            ARR(5:(end-1),:);
                y1=             ARR(end,:); % ORIGNAL PERMUTATION
                
                % Selection of K INDEPENDENT columns of MAXIMUM confidence
                CurrentRowNumber=1;
                Gtemp=          [];
                y2=             1:n;
                S_G=            [S_G;y2;S_EncWord;S_HardDecision;y1];
                while CurrentRowNumber<=k
                    CurrentColumn=  S_G(:,index_y2_1);
                    index_y2_1=     index_y2_1+1;
                    if CurrentColumn(CurrentRowNumber)==0
                        Gtemp=      [Gtemp,CurrentColumn];
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
                TotalError2(outer)=TotalError2(outer)+(ErrorMat>0);
                
            end
            
        end
    end
    WORDSARR=[WORDSARR;snr,TotalWords];
    ERRORARR=[ERRORARR;snr,TotalError2];
    BERARR=[BERARR;snr,(TotalError2(1)/TotalWords(1))]
end
semilogy(BERARR(:,1),BERARR(:,2))
grid on;
end

% function [ber]=test1()
% 
% 
% h=comm.AWGNChannel('EbNo',1);
% ber=[];
% X=randi([0 1],1,10000000);
% 
% x=2*X-1;
% % scatterplot(x)
% for snr=1:0.5:15
%     
% xn=awgn((x),snr);
% % scatterplot(xn)
% x2=xn>0;
% 
% error=sum(mod(x2+X,2));
% ber=[ber error/length(X)];
% 
% end
%  
% snr=1:0.5:15;
% semilogy(snr,ber,'kx-','linewidth',1);
% grid on;
% % noisyx=step(h,x);
% % scatterplot(noisyx)
% 
% end