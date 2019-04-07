function bvec = binvec (dec_vec)

  maxlen = ceil (log2 (max (dec_vec) + 1));
  x = []; bvec = zeros (length (dec_vec), maxlen);
  for idx = maxlen:-1:1
    tmp = mod (dec_vec, 2);
    bvec(:,idx) = tmp.';
    dec_vec = (dec_vec - tmp) ./ 2;
  end

end
%this basically converts the vector in decimal to binary