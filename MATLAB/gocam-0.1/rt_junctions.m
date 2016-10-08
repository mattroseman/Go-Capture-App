function [X,Y] = rt_junctions(RT1, RT2, sz)

  RT1(:,2) = (RT1(:,2) + 180) / 360 * 2 * pi;
  RT2(:,2) = (RT2(:,2) + 180) / 360 * 2 * pi;
  
  lines1 = size(RT1, 1);
  lines2 = size(RT2, 1);
  X = zeros(lines1, lines2);
  Y = zeros(lines1, lines2);
  for a = 1:size(RT1,1)
    for b = 1:size(RT2,1)
      r1 = RT1(a,1);
      t1 = RT1(a,2);
      r2 = RT2(b,1);
      t2 = RT2(b,2);
      
      kx1 = -cos(t1);
      ky1 = sin(t1);
      kx2 = -cos(t2);
      ky2 = sin(t2);
      
      cx1 = r1 * kx1 + sz(2) / 2;
      cy1 = r1 * ky1 + sz(1) / 2;
      cx2 = r2 * kx2 + sz(2) / 2;
      cy2 = r2 * ky2 + sz(1) / 2;

      % Rotate
      [x,y] = junction([cx1 cy1], [ky1 -kx1], [cx2 cy2], [ky2 -kx2]);
      X(a,b) = x;
      Y(a,b) = y;
    end
  end