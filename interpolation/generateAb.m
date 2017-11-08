function [ A b ] = generateAb( image, raw, regions, region_index, color, filter_len )
%generateAb creates the matrices A, b for the region "region_index" in
% 1,2,3 and for color "color". Since there are not the same number of pixels 
% in each region for different colors, each color must be considered separately.

offset = (filter_len-1)/2;

[row, col] = find(regions(1+offset:end-offset, 1+offset:end-offset, color) == region_index);
row = row + offset;
col = col + offset;


for j = 1:length(col)
    for i = 1:length(row)
        tempA = raw(row(i)-offset:row(i)+offset, col(j)-offset:col(j)+offset, color);
        A(sub2ind([length(row) length(col)], i, j),:) = tempA(:);
    end
end

tempb = image(row,col,color);
b = tempb(:);

end




