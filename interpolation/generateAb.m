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

if(isempty(row))
    empty = 1;
    A = 0;
    b = 0;
    return;
end

A = zeros(length(row), filter_len.^2);

% TODO see if there's a more efficient way to create 
% A as this loop is really slow (linear indexing?) 
for i = 1:length(row)  
    tempA = raw(row(i)-offset:row(i)+offset, col(i)-offset:col(i)+offset, color);
    A(i,:) = tempA(:);
end

if image==0; 
    b = 0;
    return; 
end

image_color = image(:,:,color);
b = image_color(sub2ind(size(image), row, col));

end




