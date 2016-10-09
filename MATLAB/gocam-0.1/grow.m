fprintf(1, 'Grow the grid');

rt1 = [radiuses(hrt1(:,1)) thetas2(hrt1(:,2))];
rt2 = [radiuses(hrt2(:,1)) thetas2(hrt2(:,2))];

while ((size(rt1, 1) < 19) | (size(rt2, 1) < 19))
  if (g_display)
    imagesc(limg); cm; 
    drawgrid(rt1, rt2, size(limg), [0 0 1]);
    wait_key;
  end

  
  % Tune grid before growing
  
  rt1 = tune_grid(rt1, rt2, limg, himg, radiuses, thetas);
  rt2 = tune_grid(rt2, rt1, limg, himg, radiuses, thetas);


  % Find best addition to one direction

  if (size(rt1, 1) <= size(rt2, 1))
    Art = extrapolate_rt(rt1, 0);
    Brt = extrapolate_rt(rt1, 1);

    scoreA = borderscore_rt(Art, rt2, limg);
    scoreB = borderscore_rt(flipud(Brt), rt2, limg);

    if (scoreA > scoreB)
      rt1 = Art;
    else
      rt1 = Brt;
    end
  end
  
  % Find best addition to other direction

  if (size(rt2, 1) < size(rt1, 1))
    Art = extrapolate_rt(rt2, 0);
    Brt = extrapolate_rt(rt2, 1);

    scoreA = borderscore_rt(Art, rt1, limg);
    scoreB = borderscore_rt(flipud(Brt), rt1, limg);

    if (scoreA > scoreB)
      rt2 = Art;
    else
      rt2 = Brt;
    end
  end
  
  fprintf(1, '.');
end

% Final optimization
rt1 = tune_grid(rt1, rt2, limg, himg, radiuses, thetas);
rt2 = tune_grid(rt2, rt1, limg, himg, radiuses, thetas);

fprintf(1, 'ok\n');
