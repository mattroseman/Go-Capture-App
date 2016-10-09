function [x,y] = junction(c1, k1, c2, k2)
  A = [k1(1), -k2(1); k1(2), -k2(2)];
  b = [c2(1) - c1(1); c2(2) - c1(2)];
  
  t = A\b;
  x = c1(1) + t(1) * k1(1);
  y = c1(2) + t(1) * k1(2);
