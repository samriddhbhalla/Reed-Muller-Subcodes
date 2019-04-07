 function [C, G] = reedmullerenc_v2 (word, G, k, M)
  %k is sum of binomial
  
  C = zeros (size(word,1),2.^M);
  
 % size(word,1)
  
  for i = 1:size(word,1)
    C(i,:) = mod (word(i,:)*G, 2);
  end

end