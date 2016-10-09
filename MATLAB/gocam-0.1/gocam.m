%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global parameters

global g_display;
global g_wait;
global g_remove_win;
global g_load_grids;
global g_print_results;

% Display intermediate results
g_display = 1;

% Wait keypress between steps
g_wait = 0;

% The width of the window for median-based peak removing
g_remove_win = 10;

% Load stored grids instead of computing
g_load_grids = 0;

% Print results for the report
g_print_results = 0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterate test images

for img_num = 1:6
  
  tic;


  % Open new window for each image
  figure;

  
  % Load image: gray-scale image 'gimg'
  img_str = sprintf('%03d', img_num);
  jpg_file = strcat('img/', img_str, '.jpg');
  load_image;

  if (g_display)
    imagesc(gimg); cm;
    drawnow;
    wait_key;
  end
  
  
  % Compute line image 'limg' and Hough image 'himg'
  lines;
  if (g_display)
    imagesc(limg); cm;
    wait_key;
  end
  hough;
  if (g_display)
    imagesc(himg); cm;
    wait_key;
  end

  
  % Find general orientation of the lines: 'theta1', 'theta2'
  initial_thetas;
  
  
  % Find the a small grid candidate
  hrt1 = init_grid(himg, theta1);
  hrt2 = init_grid(himg, theta2);

  if (g_display)
    imagesc(himg); cm;
    hold on;
    plot(hrt1(:,2), hrt1(:,1), 'rx');
    plot(hrt2(:,2), hrt2(:,1), 'yx');
    hold off;
    wait_key;
  end
  
  
  % Load stored grids or compute them
  if (g_load_grids)
    load(strcat(img_str, '.mat'), 'rt1', 'rt2');
  else
    grow;
    save(strcat(img_str, '.mat'), 'rt1', 'rt2');
  end

  
  % Find stones
  find_stones;

  toc;
  
  
  % Display results
  imagesc(gimg);
  drawgrid(rt1, rt2, size(gimg), [0 0 1], stones);
  wait_key;
end