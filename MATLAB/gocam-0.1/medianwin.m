function mm = medianwin(m, win)
  mm = m;
  [height,width] = size(m);
  
  for r = 1:height
    for c = 1:width
      r1 = max([1 r-win]);
      c1 = max([1 c-win]);
      r2 = min([height r+win]);
      c2 = min([width c+win]);
      
      area = m(r1:r2, c1:c2);
      mm(r,c) = median(area(:));
    end
  end
    