function [ image_interp ] = linInterp( raw, regions, empty_flag, filter )
%INTERPOLATE reinterpolates the raw image with the filter "filter"
%depending on the color and region.

imsize = size(regions);
nb_color = 3;
nb_region = 3;
filter_len = length(filter{1,1});
offset = (filter_len-1)/2;

b_est   = cell(nb_color, nb_region);
A_whole = cell(nb_color, nb_region);

for i = 1:nb_color
    for j = 1:nb_region
        if(empty_flag(i,j) == 1); continue; end;
        % TODO generateAb really really slow for whole image
        [A_whole{i,j}, ~] = generateAb(0, raw, regions, j, i, filter_len);
        b_est{i,j} = A_whole{i,j}*reshape(filter{i,j}, filter_len.^2, 1);
    end
end

% reordering b_est so that it's an image

rangeR = 1+offset:imsize(1)-offset; % row range
rangeC = 1+offset:imsize(2)-offset; % column range

regions_trunc = regions(rangeR, rangeC, :);
image_interp  = zeros(size(regions_trunc));

for i = 1:nb_color
    for j = 1:nb_region
        pixels = zeros(size(image_interp(:,:,1)));
        [row, col] = find(regions_trunc(:,:,i) == j);
        index = sub2ind(size(pixels), row, col);
        pixels(index) = b_est{i,j}; 
        image_interp(:,:,i) = image_interp(:,:,i)+pixels;
    end
end 
end

