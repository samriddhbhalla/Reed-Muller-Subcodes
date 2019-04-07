function gen = generate(m)
%%%This is coded according to the paper
% g=cast([1 1;0 1],'uint8');
% gen=cast([1 1;0 1],'uint8');
g=[1 1;0 1];
gen=[1 1;0 1];
for i=2:m
    gen=kron(g,gen);
end