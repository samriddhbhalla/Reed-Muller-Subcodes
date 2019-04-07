function x=main(k,m)
x=0;
g=generate(m); %get the generator matrix
t=t_min(k,m); %get t_min
pos=0;
for i=0:t-1
   pos=pos+nchoosek(m,i); 
end
g2=g(1:pos); %get g_(t-1)
%g2 needs some modification
g_extra=g(pos+1:);%just edit the syntax later please do not forget aboot it
T= ;% It has rest of the mCt-1 rows of g matrix;

s=pos+nchoosek(m,t)-k;% total number of rows that are required to be present in G_extra

while()% we dont get required number of stupid rowss
    overlap=func(T,g_extra);% basically we need transpose of g_extra;lol and then calculate sum of rows;
    sumOfRows= calcSumOfRow(overlap);%% now we need min element of the sum of rows. 
    index=minSum(sumOfRows);
    g_extra=[g_extra;T(index:)];%just adjust the stupid syntax
end

g2=[g2;g_extra];