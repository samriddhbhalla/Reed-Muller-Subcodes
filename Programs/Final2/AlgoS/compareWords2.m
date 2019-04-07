function nosErrors = compareWords2(word1,word2)
   diffMatrix=mod(word1+word2,2);
   nosErrors=sum(diffMatrix,2);
end