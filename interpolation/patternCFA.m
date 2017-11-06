function [ p ] = patternCFA( index )
%PATTERNCFA returns a CFA pattern given an index.
%   index between 1 and 36, as there are 36 different CFA patterns

if index == 1; p = [3 2; 2 1];
else           p = [3 2; 1 3]; end;
end

