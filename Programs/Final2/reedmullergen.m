
function G = reedmullergen(R, M)

  G = ones (1, 2^M);
  if (R == 0)
    return;
  end

  a = [0];
  b = [1];
  V = [];
  for i = 1:M;
    row = repmat ([a, b], [1, 2^(M-i)]);
    V(i,:) = row;
    a = [a, a];
    b = [b, b];
  end

  G = [G; V];

  if (R == 1)
    return;
  else
    r = 2;
    while (r <= R)
      p = nchoosek (1:M, r);
      temp = V(p(:,1),:) .* V(p(:,2),:);
      for i = 3:r
        temp = temp .* V(p(:,i),:);
      end
      G = [G; temp];
      r = r + 1;
    end
  end

end
