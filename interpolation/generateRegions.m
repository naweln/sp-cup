function [ regions ] = generateRegions( image, T )
%generateRegions returns matrix regions of same size as the image. Each
%pixel will have a value 1, 2, or 3 associated with it depending on the
%region it belongs to.
% regions: 1 = horizontal gradient, 2 = vertical gradient, 3 = smooth 

nb_color = 3;
imsize = size(image);

H = zeros(imsize); 
V = zeros(imsize); % to be cropped
% H matrix containing horizontal gradient calculation for each pixel in
% image same for V except vertical gradient

shiftU = [image(1+2:end,:,:); image(end-1:end,:,:)];
shiftD = [image(1:2,:,:)    ; image(1:end-2,:,:)];
shiftL = [image(:,1+2:end,:)  image(:,end-1:end,:)];
shiftR = [image(:,1:2,:)      image(:,1:end-2,:)];

for i = 1:nb_color
   H(:,:,i) = abs(shiftU(:,:,i) + shiftD(:,:,i) - 2*image(:,:,i));
   V(:,:,i) = abs(shiftL(:,:,i) + shiftR(:,:,i) - 2*image(:,:,i));
end

regions = 3*ones(imsize) - 2*((H-V)>T) - 1*((V-H)>T);

end

