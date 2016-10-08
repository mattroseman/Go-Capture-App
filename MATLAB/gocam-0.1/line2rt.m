function rt = line2rt(x1, y1, x2, y2, cx, cy)
  kx = x2-x1;
  ky = y2-y1;
  [x,y] = junction([x1, y1], [kx ky], [cx cy], [ky -kx]);

  x = x - cx;
  y = y - cy;
  
  r = sqrt(x^2 + y^2);
  t = atan2(-y,x) / pi * 180;
  if (t < 0)
    t = t + 360;
  end
  rt = [r t];