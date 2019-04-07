function EncWordErr=makeErrorArchived(EncWord,nosErr)
EncWordErr=EncWord;
for idx=1:nosErr
    EncWordErr(:,randi(128))=~EncWordErr(:,idx);
end