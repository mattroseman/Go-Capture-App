function score = borderscore(x, y, limg)

  [height, width] = size(x);
  
  values = [];
  for c = 1:width
    [tmp, tmp, tmp, s] = linesum(limg, x(1, c), y(1, c), x(2, c), y(2, ...
						  c));
    values = [values; s(:)];
  end
  
  score = mean(values);
  