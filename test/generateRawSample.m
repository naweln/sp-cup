function [ raw_sample ] = generateRawSample( file_name, p, decimation_factor )
%GENERATESAMPLE returns a raw sample 
%   The function first downsamples the image (with file name file_name) by
%   a decimation factor decimation_factor. It then "samples" it with a CFA
%   patter p. It then returns this raw sample, which could be seen as a raw
%   image prdocued with a CFA pattern p.

%% Intialisation
channel_len = 3; % RGB channel length.
image = imread(file_name);
image_down = image(1:decimation_factor:end, 1:decimation_factor:end, :);
imsize_down = size(image_down);

%% CFA matrix generation
% red = 1, green = 2, blue = 3

P = zeros(size(p,1), size(p,2), channel_len);
for m=1:3
    color = find(p == m); 
    [j,k] = ind2sub(size(p),color);
    for l=1:length(j)
        P(j(l),k(l),m) = 1; 
    end 
end

% we repeat the CFA pattern in order to do CFA sampling
% via matrix operations.
r = imsize_down(1)/length(p);
c = imsize_down(2)/length(p);
CFA = repmat(P,r,c,1);

%% CFA Sampling

raw_sample = zeros(imsize_down(1), imsize_down(2), channel_len);
for color=1:channel_len
    raw_sample(:,:,color) = uint8(image_down(:,:,color)).*uint8((CFA(:,:,color))); 
end

raw_sample = uint8(raw_sample);

end

