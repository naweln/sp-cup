clear all

%% Initialisation
channel_len = 3; % RGB channel length.
file_name = '../data-subset/18.jpg';
image = double(imread(file_name));

% Bayer CFA // red = 1, green = 2, blue = 3
p = [3 2; 2 1];  
% down sampling factor
decimation_factor = 5; 
% get raw sample from CFA p.
raw_sample = buildRaw( p, image);

% Filters
filter_width = 3; 
h(:,:,1) = [1 2 1; 2 4 2; 1 2 1]./4;
h(:,:,2) = [0 1 0; 1 4 1; 0 1 0]./4;
h(:,:,3) = h(:,:,1);

% "Random" filter of width 5 to test modularity. Test ok.
% filter_width = 5; 
% h(:,:,1) = [0.1 0.1 0.1 0.1 0.1; 0.1 1 2 1 0.1;0.1 2 4 2 0.1;0.1 1 2 1 0.1; 0.1 0.1 0.1 0.1 0.1]./4;
% h(:,:,2) = [0 0 0 0 0; 0 0 1 0 0;0 1 4 1 0;0 0 1 0 0; 0 0 0 0 0]./4;
% h(:,:,3) = h(:,:,1);

%% Interpolation

imsize_raw = size(raw_sample);
interp_sample = zeros(imsize_raw(1), imsize_raw(2), channel_len);

for color=1:channel_len
   interp_sample(:,:,color) = imfilter(raw_sample(:,:,color), h(:,:,color)); 
end

%imshow(image_interp/256);

%% Interpolation Coeffiecients (for small test image - impossible for large image > 100x100)
% solve system Ax = b
% See part IV of Nonintrusive Component Forensics...

% Test on a smaler sample
step = 170; % size of small sample
raw_sample_small = raw_sample(1:step, 1:step, :);
interp_sample_small = interp_sample(1:step, 1:step, :);

[ A, b ] = generateAb( raw_sample_small, interp_sample_small, filter_width );



%% Solving the equation improv (least squares)

A = double(A);
for color = 1:channel_len
   x_leastsquare(:,color) = (A(:,:,color)'*A(:,:,color))\A(:,:,color)'*b(:,color); 
end

%% interpolation leastsquare

x_mat = zeros(filter_width,filter_width,channel_len);
for color=1:channel_len
    x_mat(:,:,color) = reshape(x_leastsquare(:,color), [filter_width, filter_width])';
end

for color=1:channel_len
   image_interp_leastsquare(:,:,color) = imfilter(raw_sample(:,:,color), x_mat(:,:,color)); 
end

imshow(image_interp_leastsquare);

%% Solving the equation (using SVD doesn't work yet)

% for color = 1:nb_colors
%     combined = [A(:,:,color) b(:,color)];
%     [U,S,Vs] = svd(double(combined));
%     V=Vs';
%     x(:,color) = -V(:,end)./V(end,end);
% end

% %% error between bilinear interpolated image and estimated filter using least squares
% 
% %imshow(abs(double(image_interp_leastsquare)-double(image_interp))/256)