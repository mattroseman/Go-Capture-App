function score = borderscore_rt(rt1, rt2, limg)
  [x,y] = rt_junctions(rt1([1 2], :), rt2, size(limg));
  score = borderscore(x, y, limg);