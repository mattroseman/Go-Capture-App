function rt1 = tune_grid(rt1, rt2, limg, himg, radiuses, thetas)
  lines1 = size(rt1, 1);

  limg = limg - min(limg(:));
  limg = limg / max(limg(:));

  himg = himg - min(himg(:));
  himg = himg / max(himg(:));

  t = linspace(-1, 1, 7);
  s = sign(t);
  t = s .* abs(t).^1.5;

  for l = 1:lines1

    best = -Inf;
    changed = 1;
    while (changed)
      changed = 0;
      [x1, y1, kx1, ky1, x2, y2, kx2, ky2] = ...
	  grid_line(rt1(l,:), rt2, size(limg));
      for d1 = 3*t
	for d2 = 3*t
	  tx1 = x1 + d1*kx1;
	  ty1 = y1 + d1*ky1;
	  tx2 = x2 + d2*kx2;
	  ty2 = y2 + d2*ky2;
	  
	  [tmp, tmp, tmp, values] = linesum(limg, tx1, ty1, tx2, ty2);
	  ivalue = mean(values);
	  
	  rt = line2rt(tx1, ty1, tx2, ty2, size(limg,2)/2, size(limg,1)/2);
	  hrt = rt2hrt(rt, radiuses, thetas);
	  hvalue = sumpoints(himg, fliplr(hrt), 1);

	  value = 0.9 * ivalue + 0.1 * hvalue;
	  if (value > best)
	    best = value;
	    best_rt = rt;
	    best_xy = [tx1 tx2 ty1 ty2];
	    best_hrt = hrt;
	    changed = 1;
	  end
	  
	end
      end
      rt1(l,:) = best_rt;
    end
  end