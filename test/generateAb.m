function [ A, b ] = generateAb( raw_sample, interp_sample, filter_width )
%GENERATEAB returns the matrices A, b. such that Ax = b
%   The function takes a raw sample which through some filter x creates
%   interp_sample. In order to estimate x, we set up Ax = b. 
%   Note that A and b have an extra dimension for the R, G, B set up.
%   Note that the filter width is assumed to be odd, and also the filter
%   itself is assumed to be square.


imsize_raw = size(raw_sample);
row_length = imsize_raw(1);

% filter length in any direction from center of filter.
f_len = (filter_width - 1) / 2;

%% Generate A

for color=1:3
    for col = (f_len+1):imsize_raw(2)-f_len
        for row = (f_len+1):row_length-f_len
            
            temp = raw_sample(row-f_len:row+f_len, col-f_len:col+f_len, color)';
            index = (row-f_len)+(row_length-(2*f_len))*(col-(f_len+1));
            A(index,:,color) = temp(:);
            
        end
    end
end

%% Generate b

for color=1:3
   temp = interp_sample((f_len+1):end-f_len,(f_len+1):end-f_len,color)'; 
   b(:,color) = temp(:);
end


end

