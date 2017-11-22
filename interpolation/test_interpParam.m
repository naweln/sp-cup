clear all;
image = double(imread('../data-subset/26.jpg'));

step = 200;
row_range = 150:350;
column_range = 1000:1200;
filter_len = 7; % must be odd number
method = 'svd';
threshold = 8;

[p, x] = interpParam(image, row_range, column_range, threshold, filter_len, method);
