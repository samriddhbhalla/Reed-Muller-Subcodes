%IN CASE WE ARE GIVEN A G M-FOLD MATRIX LIKE THE ONE IN THE PAPER WE CAN
%FIND THE INDIVISUAL WTS OF EACH ROW;

function p =getWtOfEachRow(G, M)

size=0;
for idx=0:M
    size=size+nchoosek(M,idx);
end
p=zeros(size,1);
for idy=1:size
   p(idy)= sum(G(idy, :)); 
end

end