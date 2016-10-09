fprintf(1, 'Loading image %s...', jpg_file);

img = double(imread(jpg_file));
gimg = mean(img,3);
gimg = gimg - min(gimg(:));
gimg = gimg / max(gimg(:));

fprintf(1, 'ok\n');
