fprintf(1, 'Hough transform...');

[height, width] = size(limg);
maxsize = max([height width]);
wlimg = nrm(limg);

% Compute 'wlimg', the line image weighted with a Gaussian
t = linspace(-1,1,height);
wlimg = wlimg .* repmat(exp(-(t(:)/0.5).^2), 1, width);
t = linspace(-1,1,width);
wlimg = wlimg .* repmat(exp(-(t(:)'/0.5).^2), height, 1);
wlimg = nrm(wlimg);

% Hough transform
thetas2 = (0:359)';
thetas = thetas2(1:length(thetas2)/2);
[himg0,radiuses] = radon(wlimg,thetas);  

% Extend the hough image to cover degrees 0--360.
himg = [himg0 flipud(himg0)];

% Filter and cut to amplify the peaks
H = -peakfilter(5);
himg = imfilter(himg, H);
himg(find(himg < 0)) = 0;

fprintf(1, 'ok\n');
