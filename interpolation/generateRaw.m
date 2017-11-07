function [ raw ] = generateRaw( p, image )
%generateRaw makes raw image from the CFA pattern p and the image image.

nb_color = 3;
imsize = size(image);

r = ceil(imsize(1)/size(p,1));
c = ceil(imsize(2)/size(p,2));
CFA = repmat(p,r,c,1);
if(~(size(CFA,1) == imsize(1))) % truncating CFA if too big
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

