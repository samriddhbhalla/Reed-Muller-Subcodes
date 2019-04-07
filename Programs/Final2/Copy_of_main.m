function [nosErrors,EncWord1,EncWord2,EncWord3,RecWord1,errorMat1,RecWord2,errorMat2,RecWord3,errorMat3]=main()

k=128;
m=8;
n=256;
r=4;
nosWords=1000;
nosErrors=[0 0 0];
col=k;
epsilon=.25;

[G1,y1]=main1_v2(k,r,m);
[G2,y2]=main2_v2(k,r,m);
[G3,y3]=main3(k,r,m);

[PCM1,~]=pcmgen(n-k,m-r-1,m,y1);
[PCM2,~]=pcmgen(n-k,m-r-1,m,y2);
[PCM3,~]=pcmgen(n-k,m-r-1,m,y3);

[EncWord1,EncWord2,EncWord3,~]=wordGenerator_v4(nosWords,col,G1,G2,G3);

[RecWord1,errorMat1]=makeError(EncWord1,epsilon);
[RecWord2,errorMat2]=makeError(EncWord2,epsilon);
[RecWord3,errorMat3]=makeError(EncWord3,epsilon);

for outer=1:3
    outer
    if(outer==1)
        RecWord=RecWord1;
        errorMat=errorMat1;
        PCM=PCM1;
    elseif(outer==2)
        RecWord=RecWord2;
        errorMat=errorMat2;
        PCM=PCM2;
    else
        RecWord=RecWord3;
        errorMat=errorMat3;
        PCM=PCM3;
    end
    
    for idxWord=1:nosWords
        currentWord=RecWord(idxWord,:);
        erasurePattern=-errorMat(idxWord,:);    %This is location of all erasures
        erasureWeight=sum(erasurePattern);      % this is total number of erasures
        erasureIndex=zeros(1,erasureWeight);    % this will note all indices of erasures
        erasureIndexCtr=0;                      % Counter for var@(erasureIndex)
        % reduced PCM
        B=mod(PCM*(currentWord).',2);
        if(sum(B)~=0)
            
            H=PCM;
            for idx=n:-1:1
                if(erasurePattern(idx)==0)
                    H(:,idx)=[];
                else
                    erasureIndex(erasureWeight-erasureIndexCtr)=idx;
                    erasureIndexCtr=erasureIndexCtr+1;
                end
            end
            
            if(rank(H)<erasureWeight) % no solution exists check a random comb
                X=rand(erasureWeight,1)>0.5;
                for idx=1:erasureIndexCtr
                    erasurePattern(erasureIndex(idx))=X(idx);
                end
            else
                 
                X=GJE(H,B);
%                 catch(exception)
                X=X(:,end);
%                 end
                for idx=1:erasureIndexCtr                   
                        erasurePattern(erasureIndex(idx))=X(idx);
                end
            end %if(rank...
            currentWord=currentWord+erasurePattern;
            B2=mod(PCM*currentWord.',2);
            
            if(sum(B2)~=0)
                nosErrors(outer)=nosErrors(outer)+1;
            end
            
        end     %if(B~=... ie NoError
    end
    
end
end