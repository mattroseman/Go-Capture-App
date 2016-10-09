function rt = rt2hrt(rt, radiuses, thetas)
  rt(:,1) = rt(:,1) - radiuses(1) + 1;
  rt(:,2) = rt(:,2) - thetas(1) + 1;