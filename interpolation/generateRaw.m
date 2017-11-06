function [ raw ] = generateRaw( p, image )
%BUILDCFA builds CFA of size imsize(1) x imsize(2) with pattern p.
%   elements in p are either 1 = red, 2 = green or 3 = blue. Example, Bayer
%   CFA has p = [3 2; 2 1].

nb_color = 3;
imsize = size(image);

P = zeros(size(p,1), size(p,2), nb_color);
for m = 1:nb_color
    i = find(p == m); 
    [j,k] = ind2sub(size(p),i);
    for l=1:length(j)
        P(j(l),k(l),m) = 1; 
    end 
end

r = ceil(imsize(1)/length(p));
c = ceil(imsize(2)/length(p));
CFA = repmat(P,r,c,1);
if(~(size(CFA,1) == imsize(1)))
    CFA = CFA(1:end-1,:,:);
end
if(~(size(CFA,2) == imsize(2)))
    CFA = CFA(:,1:end-1,:);
end

raw = zeros(imsize(1), imsize(2), nb_color);
for i=1:nb_color
    raw(:,:,i) = image(:,:,i) .* CFA(:,:,i);
end

end

