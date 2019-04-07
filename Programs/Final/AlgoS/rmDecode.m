% k=sum of binomial;
function [B, Code]=rmDecode(recvec,R,M,k)

%% if we use the kroneker product wala G;
%  G=sorter(G,M);
%  G=G(1:k, :);
 G=reedmullergen(R,M);
[nosWords,length]=size(recvec);%rows and columns
Code=-1*ones(nosWords,k);

%% predefine the Pi matrix for simplicity in retrival
Pi{1}=[0];
I=1:M;
for z=1:M
    Pi{z+1}=z;
end
z=z+1;
for r=2:R
   temp=nchoosek(I,r);
   for zz=1:nchoosek(M,r);
       Pi{z+zz}=temp(zz, :);       
   end
   z=z+zz;
end
%%
for idx=1:nosWords
   b=recvec(idx, :);%Current encoded word to be decoded
   Cd=-1*ones(1,k);%currently decoded word % Preset to 1
   Degree=R;%Current Degree of the R+1 step; We go in reverse
   GCopy=G;
   if(R==0)%basic parity check ie here k=1;
       Cd=majorty_logic_check(b);
       Code(idx, :)=Cd;
       
       B(idx, :)=mod (Cd*G, 2);
       continue;
   end
   lastLength=size(Pi{k},2);%length(Pi{k});
   for step=k:-1:1
        %whenever there is a change in length of Pi ie a change in order
        %what we do is that we update the received vector. also in case R=1
        %it means we have come to the final step where we need to do the
        %parity check of the updated vector. Var@(b) is the received vector
        %upon which we will do all the above operations
        modRec=[];
        if(lastLength~=size(Pi{step},2) || step==1)
            modRec=mod(Cd(step+1: end)*GCopy(step+1: end, :),2);%basically reencode the last lines and delete the copy slowly in R+1 steps
            b=mod(b+modRec,2);
            GCopy(step+1:end, :)=0;
            Degree=Degree-1;
            if(step==1)
                Cd(step)=majorty_logic_check(b);
                break;
               %put parity check case here; 
            end
        end
        lastLength=size(Pi{step},2);
        Si=Pi{step};     %indices of set S 
        Si=sort(Si);
        
        perm_Cij=de2bi(0: 2.^(Degree)-1,'left-msb');    %All the possible combination of C_i_j belonging to {0,1} anj j=0,1,.....,r-l-1: l = 0,1,2,.....,m-1,m
        
        powOf2S=2.^(Si-1);
        powOf2S=repmat(powOf2S, 2.^(Degree), 1);
        S=sum(perm_Cij.*powOf2S,2);   %The set S %Note the dim of sum is 2 ie along rows not columns
       
        U=1:M;  %Universal Set % E=U\pi{step}
        Ei=setdiff(U,Si);
%         Ei=sort(Ei-1);  %this step is just for clarity will be removed later
        if(size(Ei,2)~=0)   %incase R=M;        
            perm_Dij=de2bi(0:2.^(M-Degree) -1,'left-msb');
            powOf2=2.^(Ei-1);
            powOf2=repmat(powOf2,2.^(M-Degree),1);
            
            Sc=sum(perm_Dij.*powOf2,2);%the set S_c
            Sc=sort(Sc);
            %Does handle case of degree R=M; as in that case we will have
            %length of Sc=0; we would require a special case for that
        else
            Sc=[0];
        end
        checkSums=[];
        for iSc_index=1:size(Sc,1)
            B_i=S+Sc(iSc_index);%Get B0, B1, B2,......    
            b(B_i+1);
            checkSum=mod(sum(b(B_i+1)),2);
            checkSums(iSc_index)=checkSum;
        end
        Cd(step)=majorty_logic_check(checkSums);
   end
   
   Code(idx, :)=Cd;
   B(idx, :)=mod (Cd*G, 2);
end


%% function majorty_logic_check(param1)
function bit=majorty_logic_check(VECTOR)
x=(sum(VECTOR)-sum(1-VECTOR));
if(x>0)
    bit=1;
elseif(x<0)
    bit=0;
else bit=0;
end
