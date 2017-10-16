clear all

image = imread(path);
imsize = size(image);

%% DOWNSAMPLING
image_down = image(1:20:end, 1:20:end, :);

%% BAYER CFA 
% red = 1, blue = 2, green = 3

p(1,1) = 2; p(1,2) = 3; p(2,1) = 3; p(2,2) = 1; 

P = zeros(size(p,1), size(p,2), 3);
for m=1:3
    i = find(p == m); 
    [j,k] = ind2sub(size(p),i);
    for l=1:length(j)
        P(j(l),k(l),m) = 1; 
    end 
end

r = imsize(1)/length(p);
c = imsize(2)/length(p);
CFA = repmat(P,r,c,1);



