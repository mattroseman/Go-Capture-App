function drawgrid(rt1, rt2, sz, col, stones)
  [x,y] = rt_junctions(rt1, rt2, sz);
  lines1 = size(rt1, 1);
  lines2 = size(rt2, 1);
  for i = 1:lines1
    H = line([x((i-1)*lines2+1) x(i*lines2)], [y((i-1)*lines2+1) y(i*lines2)]);
    set(H, 'Color', col);
  end

  for i = 1:lines2
    H = line([x(i) x((lines1-1)*lines2+i)], [y(i) y((lines1-1)*lines2+i)]);
    set(H, 'Color', col);
  end
  
  % Display stones
  if (nargin == 5)
    hold on;
    white = find(stones == 1);
    black = find(stones == -1);
    
    W1 = plot(x(white), y(white), 'o');
    set(W1, 'Color', col, 'LineWidth', 1);

    B1 = plot(x(black), y(black), '*');
    set(B1, 'Color', col, 'LineWidth', 1);
    
    hold off;
  end
