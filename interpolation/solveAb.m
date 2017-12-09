function [ x ] = solveAb( A, b, filter_len, method )
%SOLVEAB_SVD Solves the system Ax = b using the method made explicit in the
% 'method' string (either 'svd' or 'ls', if no method specified then 'ls' 
% by default)

% if strcmp(method, 'svd')
%     combined = [A b];
%     [~,~,V] = svd(double(combined));
%     x = -V(:,end)./V(end,end);
%     x = reshape(x(1:end-1), filter_len, filter_len);
% else 
    x = (A'*A)\A'*b;
    x = reshape(x, filter_len, filter_len);
% end

end

