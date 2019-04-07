function [A2,B,X]=LinEq(A) 
syms a b c;
A2=A;
a=0;
b=0;
c=0;

X=[0 0 0 0 a 0 1 0 b c 1 1 1 0 1 0];
Erasure=[0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0];
NosErasures=sum(Erasure);
% for i=size(Erasure,2):-1:1
%     if(Erasure(i)==0) 
%        A2(:,i)=[]; 
%     end
% end
% B=0;
B=A2*X.';
Erasure=[0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0];
A2=A2.*repmat(Erasure,5,1);
% B=mod(A*X.',2);
X=A2\B;
X=X*NosErasures;
X=mod(X,2);
end