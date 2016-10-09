fprintf(1, 'Create the line image...');

limg = imfilter(gimg, peakfilter(5));
limg(find(limg < 0)) = 0;
limg = nrm(limg);

fprintf(1, 'ok\n');
