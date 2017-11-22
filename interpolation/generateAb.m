function [ A, b, empty ] = generateAb( image, raw, regions, region_index, color, filter_len )
%generateAb creates the matrices A, b for the region "region_index" in
% 1,2,3 and for color "color". Since there are not the same number of pixels 
% in each region for different colors, each color must be considered
% separately.
% if empty flag = 1 then no pixels in region region_index and color color exists
% in image.

empty = 0;

offset = (filter_len-1)/2;

[row, col] = find(regions(1+offset:end-offset, 1+offset:end-offset, color) == region_index);
row = row + offset;
col = col + offset;
index = sub2ind(size(regions), row, col);

if(isempty(row))
    empty = 1;
    A = 0;
    b = 0;
    return;
end

A = zeros(length(row), filter_len^2);

raw_color = raw(:,:,color);
for i = 1:filter_len^2
    A(:,i) = raw_color(index - offset + mod(i-1,filter_len) ...
             - (offset-floor((i-1)/filter_len))*size(raw,1));
end
% check if right TODO

if image == 0 
    b = 0;
else
    image_color = image(:,:,color);
    b = image_color(index);
end

end