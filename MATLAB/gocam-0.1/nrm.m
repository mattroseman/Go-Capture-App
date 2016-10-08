function M = nrm(M)
  M = (M - min(min(M)));
  M = M / max(max(M));