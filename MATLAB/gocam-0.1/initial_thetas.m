% Blur horizontally
shimg = imfilter(himg, [1 1 1 1 1]);

% Use columns 91-270 from the redundant 1-360 himg figure.
[height, width] = size(shimg);
t1 = 91;
t2 = 270;
hseg = shimg(:,t1:t2);

% Scale with vertical Gaussian to concentrate at the center
w = linspace(-1, 1, height);
hseg = hseg .* repmat(exp(-(w(:) / 0.10).^2), 1, size(hseg, 2));

% Get the first maximum [theta1 cy1]
maxes = max(hseg);
[tmp, theta1] = max(maxes);

% Remove 50 degrees around the maximum
win = 25;
len = length(maxes);
H = ones(1, len);
H(1:win) = 0;
H(len-win:len) = 0;
H = [H(len-theta1:len) H(1:len-theta1-1)];
maxes2 = maxes .* H;

% Get the second maximum
[tmp, theta2] = max(maxes2);

theta1 = theta1 + t1 - 1;
theta2 = theta2 + t1 - 1;
