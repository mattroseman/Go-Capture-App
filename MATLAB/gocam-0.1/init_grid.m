function rt = init_grid(himg, theta)
  global g_display;
  global g_wait;
  global g_remove_win;
  
  fprintf(1, 'Computing initial grid candidate...');

  % Get 20 degrees around the center maximum
  t1 = theta-10;
  t2 = theta+10;
  hseg = himg(:, t1:t2);
  
  % Gaussian weighting
  [height,width] = size(hseg);
  w = linspace(-1, 1, width);
  hseg = hseg .* repmat(exp(-(w(:)'/0.5).^2), height, 1);
  w = linspace(-1, 1, height);
  hseg = hseg .* repmat(exp(-(w(:)/0.5).^2), 1, width);
  
  % Get the maximum for each row
  s = max(hseg');
  s = s / max(s(:));

  % Get 9 best maximums 
  R = [];
  ss = s;
  for i = 1:9
    [tmp, r] = max(ss);
    ss = remove_peak(ss, r, 0, g_remove_win);
    R = [R r];
  end
  
  % Get the corresponding thetas
  [tmp, T] = max(hseg(R, :)');
  T = T + t1 - 1;
  rt = [R(:) T(:)];

  % Select 5 peaks in the middle
  rt = sortrows(rt, [1 1]);
  rows = (-2:2) + round(size(rt, 1) / 2);
  rt = rt(rows, :);

  % Fill gaps.  FIXME: assumes that only one line is missing
  drt = rt([1:4],1) - rt([2:5],1);
  minim = min(abs(drt));
  i = 1;
  while (1)

    % End if last rwo reached
    if (i == size(rt,1))
      break;
    end
    
    % Check if hole here and add if necessary
    diff = abs(rt(i,1) - rt(i+1,1));
    if (diff > minim * 1.5)
      fprintf(1, 'adding\n');
      new_rt = round((rt(i,:) + rt(i+1,:)) / 2);
      rt = [rt(1:i,:); new_rt; rt(i+1:size(rt,1),:)];
    end

    i = i + 1;
  end
  
  fprintf(1, 'ok\n');
