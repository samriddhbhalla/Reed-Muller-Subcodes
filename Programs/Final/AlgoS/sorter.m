function sort=sorter(G,M)

p=getWtOfEachRow(G,M);

g2=[p,G];
[sort,~]=sortrows(g2,-1);%'descend');
sort(:, 1)=[];
end