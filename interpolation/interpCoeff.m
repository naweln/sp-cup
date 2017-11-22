function [ x, empty_flag ] = interpCoeff( image, raw, regions, filter_len, method )
%INTERPCOEFF Given image and raw and regions, this function calculates the
%interpolation coefficients given by method "method" (either ls or svd)

nb_color = 3; nb_region = 3;

A = cell(nb_color, nb_region);
b = cell(nb_color, nb_region);
empty_flag = zeros(nb_color, nb_region);

for i = 1:nb_color
    for j = 1:nb_region
        [A{i,j}, b{i,j}, empty_flag(i,j)] = generateAb(image, raw, regions, j, i, filter_len); 
    end
end

% Solving Ax = b
% Minimal solution to equation using SVD or LS
x = cell(nb_color, nb_region);

for i = 1:nb_color
    for j = 1:nb_region
        if(empty_flag(i,j) == 1); continue; end;
        x{i,j} = solveAb(A{i,j}, b{i,j}, filter_len, method);
    end
end

end

