function [x,y,kx,ky] = rt2line(rt, cx, cy)
  t = rt(1,2) / 180 * pi;
  kx = cos(t);
  ky = -sin(t);
  x = rt(1,1) * kx + cx;
  y = rt(1,1) * ky + cy;
  kx = sin(t);
  ky = cos(t);
  
  