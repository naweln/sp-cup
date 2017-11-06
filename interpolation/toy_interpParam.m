% this script is used to test, with a toy problem, algorithm to be 
% implemented in the function interpParam.
clear all;
source_image = double(imread('../data-subset/18.jpg'));
nb_color = 3;

%% constructed image with no noise and same linear interp coeff for
%  all regions
decimation = 5;

% image under analysis is downsampled by factor "decimation" for this test phase to
% remove any characteristic features / camera specific distortions.
% TODO remove in final
image = source_image(1:decimation:end, 1:decimation:end,:); 
imsize = size(image);

% Bayer CFA (must consider sample space of all 36 possible CFAs eventually)
% TODO in final
raw = generateRaw(patternCFA(1), image);

% reinterpolating raw image to see if we can calculate the interp coeff
% (can erase all of this for final implemenation) TODO
h(:,:,1) = [1 2 1; 2 4 2; 1 2 1]./4;
h(:,:,2) = [0 1 0; 1 4 1; 0 1 0]./4;
h(:,:,3) = h(:,:,1);
image_interp = zeros(imsize(1),imsize(2),nb_color);
for i=1:nb_color
    image_interp(:,:,i) = imfilter(raw(:,:,i), h(:,:,i));
end

% finding interpolation coefficients by solving system Ax = b. A matrix
% where each row is a 3x3 block of raw sample. b interpolated corresponding
% pixel, x interpolation coefficients.
step = 8;

% can add gaussian white noise to check robustness (LS does better than
% SVD)
% raw = raw + 8*randn(size(raw));
raw_small = raw(1:step, 1:step, :);
for color = 1:nb_color 
    for col = 2:size(raw_small,2)-1
        for row = 2:size(raw_small,1)-1
            tempA = raw_small(row-1:row+1, col-1:col+1, color);
            A((row-1)+(step-2)*(col-2),:,color) = tempA(:);
        end
    end
end

interp_small = image_interp(1:step, 1:step, :);
for color = 1:nb_color 
   tempb = interp_small(2:end-1,2:end-1,color); 
   b(:,color) = tempb(:);
end

% Minimal solution to equation using SVD
for color = 1:nb_color
    combined = [A(:,:,color) b(:,color)];
    [U,S,Vs] = svd(double(combined));
    x_svd(:,color) = -Vs(:,end)./Vs(end,end);
end

x_svd = reshape(x_svd(1:end-1,:), 3, 3, 3);

for i=1:nb_color
    image_interp_svd(:,:,i) = imfilter(raw(:,:,i), x_svd(:,:,i));
end

% Minimal solution to equation using Least Squares
for color = 1:nb_color
   x_ls(:,color) = (A(:,:,color)'*A(:,:,color))\A(:,:,color)'*b(:,color); 
end

x_ls = reshape(x_ls, 3, 3, 3);

for i=1:nb_color
    image_interp_ls(:,:,i) = imfilter(raw(:,:,i), x_ls(:,:,i));
end

