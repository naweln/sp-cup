clear all

image = imread('DSC01079.jpg');
imsize = size(image);

%% Downsampling
image_down = image(1:20:end, 1:20:end, :);
imsize_down = size(image_down);

%% Bayer CFA 
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

r = imsize_down(1)/length(p);
c = imsize_down(2)/length(p);
CFA = repmat(P,r,c,1);
imshow(CFA)

%% CFA Sampling

image_sample = zeros(imsize_down(1), imsize_down(2), 3);
for i=1:3
    image_sample(:,:,i) = uint8(image_down(:,:,i)).*uint8((CFA(:,:,i))); 
end
imshow(image_sample/256);
 
%% Interpolation





