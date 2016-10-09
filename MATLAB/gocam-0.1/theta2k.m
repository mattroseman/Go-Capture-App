function [kx, ky] = theta2k(t)
  t = (t-90) / 180 * pi;
  kx = cos(t);
  ky = -sin(t);
  