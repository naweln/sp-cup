function [ P ] = patternCFA( index )
%PATTERNCFA returns a CFA pattern given an index.
%   index between 1 and 36, as there are 36 different CFA patterns
%   returns pattern in JPEG matrix format already

nb_color = 3;

switch(index)
    case 1 
        p = [3 2; 1 3];
    case 2 
        p = [1 1; 3 2];        
    case 3 
        p = [1 2; 1 3];
    case 4 
        p = [1 2; 3 1];
    case 5 
        p = [1 3; 1 2];
    case 6 
        p = [1 3; 2 1];
    case 7 
        p = [2 1; 1 3];
    case 8 
        p = [2 1; 3 1];
    case 9 
        p = [3 2; 2 1]; 
    case 10 
        p = [3 2; 2 1];
    case 11 
        p = [3 2; 2 1];
    case 12 
        p = [3 2; 2 1];
    case 13 
        p = [3 2; 2 1];
    case 14 
        p = [3 2; 2 1];
    case 15 
        p = [3 2; 2 1];
    case 16 
        p = [3 2; 2 1];
    case 17 
        p = [3 2; 2 1];
    case 18 
        p = [3 2; 2 1];
    case 19 
        p = [3 2; 2 1];
    case 20 
        p = [3 2; 2 1];
    case 21 
        p = [3 2; 2 1];
    case 22 
        p = [3 2; 2 1];
    case 23 
        p = [3 2; 2 1];
    case 24 
        p = [3 2; 2 1];
    case 25 
        p = [3 2; 2 1];
    case 26 
        p = [3 2; 2 1];
    case 27 
        p = [3 2; 2 1];
    case 28 
        p = [3 2; 2 1];
    case 29 
        p = [3 2; 2 1];
    case 30 
        p = [3 2; 2 1];
    case 31 
        p = [3 2; 2 1];
    case 32 
        p = [3 2; 2 1];
    otherwise
        p = [3 2; 1 3];
end;

P = zeros(size(p,1), size(p,2), nb_color);
for m = 1:nb_color
    i = find(p == m); 
    [j,k] = ind2sub(size(p),i);
    for l=1:length(j)
        P(j(l),k(l),m) = 1; 
    end 
end

end

