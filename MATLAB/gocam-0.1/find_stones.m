fprintf(1, 'Finding stones...');

[x,y] = rt_junctions(rt1, rt2, size(gimg));
[height, width] = size(x);

colors = zeros(size(x));
stones = zeros(size(x));
  
win = 2;
H = fspecial('disk', win);
H(find(H > 0)) = 1;

t = -win:win;
  
for r = 1:height
  for c = 1:width
    area = gimg(round(y(r,c))+t, round(x(r,c))+t);
    area = area .* H;
    col = median(area(:));
    colors(r,c) = col;
  end
end

med = medianwin(colors, 2);
colors2 = colors ./ med;

threshold = 1.2;
stones(find(colors2 > threshold)) = 1;
stones(find(colors2 < 1/threshold)) = -1;

fprintf(1, 'ok\n');
