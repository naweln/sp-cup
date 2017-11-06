clear all

image = imread('DSC01079.jpg');
imsize = size(image);

%% Downsampling
image_down = image(1:5:end, 1:5:end, :);
imsize_down = size(image_down);

%% Bayer CFA 
% red = 1, green = 2, blue = 3

p = [3 2; 2 1];
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
%imshow(CFA)

%% CFA Sampling

image_sample = zeros(imsize_down(1), imsize_down(2), 3);
for i=1:3
    image_sample(:,:,i) = uint8(image_down(:,:,i)).*uint8((CFA(:,:,i))); 
end
image_sample = uint8(image_sample);
%imshow(image_sample);
 
%% Interpolation

h(:,:,1) = [1 2 1; 2 4 2; 1 2 1]./4;
h(:,:,2) = [0 1 0; 1 4 1; 0 1 0]./4;
h(:,:,3) = h(:,:,1);

image_interp = zeros(imsize_down(1), imsize_down(2), 3);

for i=1:3
   image_interp(:,:,i) = imfilter(image_sample(:,:,i), h(:,:,i), 'replicate'); 
end

for i=1:1
   image_interp2(:,:,i) = conv2(double(image_sample(:,:,i)), double(h(:,:,i)));
end

%imshow(image_interp/256);

%% Interpolation Coeffiecients (for small test image - impossible for large image > 100x100)
% solve system Ax = b

step = 64;

image_sample_small = image_sample(2:step+1, 2:step+1, :);
for color=1:3
    for col = 2:size(image_sample_small,2)-1
        for row = 2:size(image_sample_small,1)-1
            temp = image_sample_small(row-1:row+1, col-1:col+1, color)';
            A((row-1)+(step-2)*(col-2),:,color) = temp(:);
        end
    end
end


image_interp_small = image_interp(2:step+1, 2:step+1, :);
for color=1:3
   temp = image_interp_small(2:end-1,2:end-1,color)'; 
   b(:,color) = temp(:);
end

%% Solving the equation (using SVD doesn't work yet)

%% SVD
for color = 1:3
    combined = [A(:,:,color) b(:,color)];
    [U,S,Vs] = svd(double(combined));
    V=Vs';
    x(:,color) = -V(:,end)./V(end,end);
end


%% Solving the equation (least squares)

A = double(A);
for color = 1:3
   x_leastsquare(:,color) = (A(:,:,color)'*A(:,:,color))\A(:,:,color)'*b(:,color); 
end

% least square through SVD - it works
% for color = 1:3
%     [U,S,V] = svd(double(A(:,:,color)));
%     x_svd(:,color) = (V*pinv(S)*U')*b(:,color);
% end

%% makeshift interpolation leastsquare

x_mat_svd = zeros(3,3,3);
for color=1:3
    x_mat_svd(:,:,color) = reshape(x_svd(:,color), [3, 3])';
end

x_mat_ls = zeros(3,3,3);
for color=1:3
    x_mat_ls(:,:,color) = reshape(x_leastsquare(:,color), [3, 3])';
end

for i=1:3
   image_interp_est_svd(:,:,i) = imfilter(image_sample(:,:,i), x_mat_svd(:,:,i)); 
end
for i=1:3
   image_interp_est_ls(:,:,i) = imfilter(image_sample(:,:,i), x_mat_ls(:,:,i)); 
end

imshow(image_interp_est_svd);
figure; imshow(abs(double(image_interp_est_svd)-double(image_interp))/256)


   







