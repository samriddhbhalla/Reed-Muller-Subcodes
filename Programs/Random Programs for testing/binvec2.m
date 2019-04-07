function bvec = binvec2 (dec_vec)

  maxlen = ceil (log2 (max (dec_vec) + 1));
  x = []; bvec = zeros (length (dec_vec), maxlen);
  for idx = 1:length(dec_vec)
     bvec(idx,:)=de2bi(dec_vec(idx),maxlen,'left-msb');
  end

end
%this basically converts the vector in decimal to binary
%less efficient as [1:endNum increases 