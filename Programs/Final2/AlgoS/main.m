function [ErrorRate]=main()
% wordRate=[0 0 0 0 0 0];
k=42;
m=6;
r=3;
nosWords=100;
col=k;
% nosErrors=0;
ErrorRate=[0 0 0 0 0 0 0 0 0 0];
[G1,y1]=main1_v2(k,r,m);
% [G2,y2]=main2_v2(k,r,m);
% [G3,y3]=main3(k,r,m);]
ctr=0;
ctr2=1;
for snr=1:0.5:5
    nosErrors=0;
    while(nosErrors<100)
      [EncWord1,BinWord1]=wordGenerator_v3(nosWords,col,G1);
      h=comm.AWGNChannel('EbNo',snr);
      RecWordArr=      step(h,EncWord1*2-1);
      HardDecision=RecWordArr>0;
      [~, Code1]=rmDecode_v2(HardDecision,G1,r,m,k,y1);
      nosErrors = nosErrors+compareWords(BinWord1,Code1);
      ctr=ctr+1;
    end      
    ErrorRate(ctr2)=nosErrors/ctr
    ctr2=ctr2+1;
end
semilogy(1:0.5:5,ErrorRate/100,'k!-')
grid on;
end
