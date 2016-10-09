function [total, x, y, s] = linesum(img, x1, y1, x2, y2)

  % Compute delta for moving pixel by pixel from (x1,y1) to (y1,y2)
  kx = x2 - x1;
  ky = y2 - y1;
  div = round(max([abs(kx) abs(ky)]));
  kx = kx / div;
  ky = ky / div;

  x = zeros(1, div+1);
  y = zeros(1, div+1);
  s = zeros(1, div+1);
  
  % Move along the line
  for i = 1:div+1
    x(i) = x1 + (i-1) * kx;
    y(i) = y1 + (i-1) * ky;
    
    fx = floor(x(i));
    fy = floor(y(i));
    dx = x(i) - fx;
    dy = y(i) - fy;
    
    s(i) = img(fy,fx) * (1-dx) * (1-dy) + ...
	   img(fy,fx+1) * (dx) * (1-dy) + ...
	   img(fy+1, fx+1) * (dx) * (dy) + ...
	   img(fy+1, fx) * (1-dx) * (dy);
  end
  total = sum(s);