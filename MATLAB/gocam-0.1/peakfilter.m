function F = peakfilter(sz)
  if (mod(sz, 2) == 0)
    error('SZ must be odd');
  end

  F = ones(sz);
  i = ceil(sz / 2);
  F(i,i) = -sum(sz * sz - 1);
  
  