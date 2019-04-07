function nosErrors = compareWords(BinWord,Code)
   diffMatrix=mod(BinWord+Code,2);
   nosError=sum(diffMatrix,2);
   nosErrors=sum(nosError>0);
end