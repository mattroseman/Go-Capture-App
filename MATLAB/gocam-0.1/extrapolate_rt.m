function rt = extrapolate_rt(rt, flip)
  if (flip)
    rt = flipud(rt);
  end

  % Find the center of border line
  [x0, y0, kx0, ky0] = rt2line(rt(1,:), 0, 0);
  
  % Get the previous line
  [x1, y1, kx1, ky1] = rt2line(rt(2,:), 0, 0);
  
  % Get the junction
  [jx, jy] = junction([x0 y0], [ky0 -kx0], [x1 y1], [kx1 ky1]);
  
  % Center of the new line
  x2 = x0 + (x0 - jx);
  y2 = y0 + (y0 - jy);
  
  % Projection of k1 to k0
  p = [kx1 ky1] * [kx0 ky0]';
  kx2 = p * kx0 + (p * kx0 - kx1);
  ky2 = p * ky0 + (p * ky0 - ky1);
  
  rt_new = line2rt(x2, y2, x2 + kx2, y2 + ky2, 0, 0);
  
  rt = [rt_new; rt];
  if (flip)
    rt = flipud(rt);
  end
