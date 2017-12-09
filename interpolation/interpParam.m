function [ p, x ] = interpParam( image, row_range, column_range, threshold, filter_len, method )
%interpParam given an image, it returns the CFA pattern p, and the 
%   estimated interpolation coefficients x th te at minimize error. The
%   arguments row_range and column_range specify which sub image to take
%   from the main image.

[~,p_space] = patternCFA(0); % 36 possible CFA patterns, but can be reduced if we read
              % paper carefully
offset = (filter_len-1)/2;

regions = generateRegions(image, threshold);
sub_image   = image  (row_range, column_range, :);
sub_regions = regions(row_range, column_range, :);

x_p = cell(p_space,1);
MSE = zeros(p_space,1);

for k = 1:p_space
    raw = generateRaw(patternCFA(k), image); % TODO implement other CFA patterns
    sub_raw = raw(row_range, column_range, :);
    
    [x_p{k}, empty_flag] = interpCoeff(sub_image, sub_raw, sub_regions, filter_len, method);
    
    image_interp = linInterp(raw, regions, empty_flag, x_p{k});
    image_trunc  = image(1+offset:end-offset, 1+offset:end-offset, :);
    MSE(k) = immse(image_interp, image_trunc);
end

min_index = find(MSE == min(MSE));
if(~isempty(min_index))
    x = x_p{min_index(1)};
    p = patternCFA(min_index(1));
else
    x = x_p{1};
    p = patternCFA(1);
end

end

