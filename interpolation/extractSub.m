function [row_range, col_range] = extractSub(image, dim)

if(size(dim,2) == 1); dim(2) = dim(1); end;
%dim(1): number of rows in sub image
%dim(2): number of column in sub image

start_row = randi(size(image,1)-dim(1),1);
start_col = randi(size(image,2)-dim(2),1);

row_range = start_row:start_row+dim(1)-1;
col_range = start_col:start_col+dim(2)-1;

end