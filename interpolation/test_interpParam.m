% this script is used to test the algorithm to be implemented in the
% function interpParam with a real image.

clear all;
image = double(imread('../data-subset/26.jpg'));
imsize = size(image);
nb_color = 3;

%% 
raw = generateRaw(patternCFA(1), image); %TODO implement other CFA patterns
filter_len = 5; % filter is of size 7x7
offset = (filter_len-1)/2;
step = 40;
raw_small = raw(1:step, 1:step, :);
image_small = image(1:step, 1:step, :);
width = size(raw_small,1);
height = size(raw_small,2);


for color = 1:nb_color 
    for col = 1+offset:height-offset
        for row = 1+offset:width-offset
            tempA = raw_small(row-offset:row+offset, col-offset:col+offset, color);
            A((row-offset)+(width-2*offset)*(col-offset-1),:,color) = tempA(:);
        end
    end
end

for color = 1:nb_color 
   tempb = image_small(1+offset:end-offset,1+offset:end-offset,color); 
   b(:,color) = tempb(:);
end

% Minimal solution to equation using SVD
for color = 1:nb_color
    combined = [A(:,:,color) b(:,color)];
    [U,S,Vs] = svd(double(combined));
    x_svd(:,color) = -Vs(:,end)./Vs(end,end);
end

x_svd = reshape(x_svd(1:end-1,:), filter_len, filter_len, nb_color);

for i=1:nb_color
    image_interp_svd(:,:,i) = imfilter(raw(:,:,i), x_svd(:,:,i));
end

% Minimal solution to equation using Least Squares
for color = 1:nb_color
   x_ls(:,color) = (A(:,:,color)'*A(:,:,color))\A(:,:,color)'*b(:,color); 
end

x_ls = reshape(x_ls, filter_len, filter_len, nb_color);

for i=1:nb_color
    image_interp_ls(:,:,i) = imfilter(raw(:,:,i), x_ls(:,:,i));
end
