function [total, values] = sumpoints(img, z, wgt)
  [height, width] = size(img);

  num = size(z,1);
  values = zeros(1, num);

  for i = 1:num
    x = floor(z(i, 1));
    dx = z(i,1) - x;
    y = floor(z(i, 2));
    dy = z(i,2) - y;

    if ((x < 1) || (x >= width))
      continue;
    end
    if ((y < 1) || (y >= height))
      continue;
    end
    
    value = img(y,x) * (1-dx) * (1-dy) + ...
	    img(y,x+1) * (dx) * (1-dy) + ...
	    img(y+1, x+1) * (dx) * (dy) + ...
	    img(y+1, x) * (1-dx) * (dy);
    value = value * wgt(i);
    values(i) = value;
  end
  
  total = sum(values);