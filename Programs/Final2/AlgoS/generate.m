function gen = generate(m)
%%%This is coded according to the paper
g=[1 1;0 1];
gen=[1 1;0 1];
for i=2:m
    gen=kron(g,gen);
end

end