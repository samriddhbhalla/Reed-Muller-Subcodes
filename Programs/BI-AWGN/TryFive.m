%% Parameters 
k=128;
r=4;
m=8;
n=2^m;      %Packet Length
col=k;
nosWords=1000;
x=1;
snri=1:x:5;

%% Create generator matrix
G1=main1_v2(k,r,m);     % choose 1st k rows
G2=main2_v2(k,r,m);     % choose k random rows
G3=main3(k,r,m);        % choose k rows using new proposed scheme
%% loop for all SNRs
i=0;
for snr= snri(1):x:snri(end)
    %% Extra params...
    i=i+1;
    ARR1=zeros(nosWords,3,n);
    ARR2=zeros(nosWords,3,n);
    ARR3=zeros(nosWords,3,n); 
    %% Generate words and modulate them
    [EncWordArr1,EncWordArr2,EncWordArr3,~]=wordGenerator_v4(nosWords,col,G1,G2,G3);
    ModWordArr1=2*EncWordArr1-1;
    ModWordArr2=2*EncWordArr2-1;
    ModWordArr3=2*EncWordArr3-1;
    %% Make noisy channel and pass modulated words through noisy channel
    AWGN = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', 'SignalPower', 1);
    AWGN.SNR = snr;    
    RecWordArr1=step(AWGN,ModWordArr1);
    RecWordArr2=step(AWGN,ModWordArr2);
    RecWordArr3=step(AWGN,ModWordArr3);
    %% Detection of signal at receiver side
    % Hard Decision Decoding
    HardDecArr1=RecWordArr1>0;
    HardDecArr2=RecWordArr2>0;
    HardDecArr3=RecWordArr3>0;
    %  - Confidence values formation
    ConfValArr1=abs(RecWordArr1);
    ConfValArr2=abs(RecWordArr2);
    ConfValArr3=abs(RecWordArr3);    
    PermMatrix=repmat((1:n),nosWords,1);
    
    %% Making a 3D matrix to make out life easier  
%     ARR1(:,1,:)=ConfValArr1;
%     ARR1(:,2,:)=HardDecArr1;
%     ARR1(:,3,:)=PermMatrix;
%     
%     ARR2(:,1,:)=ConfValArr2;
%     ARR2(:,2,:)=HardDecArr2;
%     ARR2(:,3,:)=PermMatrix;
%     
%     ARR3(:,1,:)=ConfValArr3;
%     ARR3(:,2,:)=HardDecArr3;
%     ARR3(:,3,:)=PermMatrix;
    %%
    [SortConfValArr1,index1]=sort(ConfValArr1,2,'descend');
    SortRecWordArr1=RecWordArr1(index1);
    SortG1=zeros(nosWords,k+1,n);
    for idx=1:nosWord
        Gtemp=[ConfValArr1(idx,:);G].';
        Gtemp=sortrows(Gtemp,-1);
        Gtemp(1,:)=[];
        Gtemp=gf(Gtemp,2);
        rnk=rank(Gtemp); 
    end
    [SortConfValArr2,index2]=sort(ConfValArr1,2,'descend');
    SortRecWordArr2=RecWordArr1(index2);
    
    [SortConfValArr3,index3]=sort(ConfValArr1,2,'descend');
    SortRecWordArr3=RecWordArr1(index3);
    
    
  
    
end