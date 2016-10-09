function [x1, y1, kx1, ky1, x2, y2, kx2, ky2] = grid_line(rt1, rt2, sz)
  lines1 = size(rt1, 1);
  lines2 = size(rt2, 1);
  
  [x1, y1] = rt_junctions(rt1, rt2(1,:), sz);
  [x2, y2] = rt_junctions(rt1, rt2(lines2,:), sz);
  
  [kx1, ky1] = theta2k(rt2(1,2));
  [kx2, ky2] = theta2k(rt2(lines2,2));
