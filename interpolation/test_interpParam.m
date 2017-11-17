% this script is used to test the algorithm to be implemented in the
% function interpParam with a real image.

clear all;
image = double(imread('../data-subset/18.jpg'));
imsize = size(image);
nb_color  = 3;
nb_region = 3;
red = 1; blue = 2; green = 3;

%% gradient / regions
threshold = 10; % threshold to be considered in a certain region
regions = generateRegions(image, threshold);
% regions: 1 = horizontal gradient, 2 = vertical gradient, 3 = smooth 

%% generating A and b
raw = generateRaw(patternCFA(1), image); %TODO implement other CFA patterns
filter_len = 7; % filter is of size filter_len x filter_len
offset = (filter_len-1)/2;
region_index = 1; % considering hor grad region to start, TODO change

% Matrices A, b cannot include whole image, first must take sub images.
step = 50;
sub_image   = image  (5*step:6*step, step:2*step, :);
sub_raw     = raw    (5*step:6*step, step:2*step, :);
sub_regions = regions(5*step:6*step, step:2*step, :);

A = cell(nb_color, nb_region);
b = cell(nb_color, nb_region);
empty_flag = zeros(nb_color, nb_region);

for i = 1:nb_color
    for j = 1:nb_region
        [A{i,j}, b{i,j}, empty_flag(i,j)] = generateAb(sub_image, sub_raw, sub_regions, j, i, filter_len); 
    end
end

%% Solving Ax = b
% Minimal solution to equation using SVD and LS
x_svd = cell(nb_color, nb_region);
x_ls  = cell(nb_color, nb_region);

for i = 1:nb_color
    for j = 1:nb_region
        if(empty_flag(i,j) == 1); continue; end;
        x_ls{i,j}  = solveAb(A{i,j}, b{i,j}, filter_len, 'ls');
        x_svd{i,j} = solveAb(A{i,j}, b{i,j}, filter_len, 'svd');
    end
end

%% Interpolation



