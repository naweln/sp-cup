% this script is used to test the algorithm to be implemented in the
% function interpParam with a real image.

clear all;
image = double(imread('../data-subset/26.jpg'));
imsize = size(image);
nb_color = 3;
red = 1; blue = 2; green = 3;

%% gradient / regions
threshold = 40; % threshold to be considered in a certain region
regions = generateRegions(image, threshold);
% regions: 1 = horizontal gradient, 2 = vertical gradient, 3 = smooth 

%% generating A and b
raw = generateRaw(patternCFA(1), image); %TODO implement other CFA patterns
filter_len = 3; % filter is of size filter_len x filter_len
region_index = 1; % considering hor grad region to start, TODO change

% Matrices A, b cannot include whole image, first must take sub images.
step = 10;
sub_image   = image  (step:2*step, step:2*step, :); % TODO change
sub_raw     = raw    (step:2*step, step:2*step, :);
sub_regions = regions(step:2*step, step:2*step, :);

[A_reg1_red, b_reg1_red] = generateAb(sub_image, sub_raw, sub_regions, region_index, red, filter_len);

%% Solving Ax = b
% Minimal solution to equation using SVD
%for color = 1:nb_color
    combined = [A_reg1_red b_reg1_red'];
    [U,S,Vs] = svd(double(combined));
    x_svd_reg1_red = -Vs(:,end)./Vs(end,end);
%end

x_svd_reg1_red = reshape(x_svd_reg1_red(1:end-1), filter_len, filter_len);

image_interp_svd_reg1_red = imfilter(raw(:,:,red), x_svd_reg1_red);


