function [ P, p_space ] = patternCFA( index )
%PATTERNCFA returns a CFA pattern given an index.
%   index between 1 and 36, as there are 36 different CFA patterns
%   returns pattern in JPEG matrix format already

nb_color = 3;
p_space  = 4;

switch(index)
    case 1 
        p = [1 2; 2 3];
    case 2 
        p = [3 2; 2 1];        
    case 3 
        p = [2 1; 3 2];
    otherwise
        p = [2 3; 1 2];
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

