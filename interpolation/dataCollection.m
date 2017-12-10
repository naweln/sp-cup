clear all;

nb_subimage = 1;
subimage_size = [512 512];
filter_len = 7; % must be odd number
method = 'ls';
threshold = 8;

startFolder = pwd;
dataFolder = '../../data';

cd(dataFolder);
contents = dir;
folder_bool = zeros(numel(contents),1);
for i=1:numel(contents)
    folder_bool(i) = isempty(strfind(contents(i).name, '.'));
end

i = 1;
while i <= numel(contents)
    if folder_bool(i) == 0
        contents(i) = [];
        folder_bool(i) = [];
    else
        i = i+1;
    end
end

cd(startFolder)

param = cell(4,1,1);
mkdir('parameters');
for i=8:numel(contents)
    mkdir(['parameters/' contents(i).name]); 
    cd([dataFolder '/' contents(i).name]);
    images = vertcat(dir('*.jpg'), dir('*.png'), dir('*.JPG'));
    cd(startFolder);
    for j=1:100%numel(images)
        image = double(imread([dataFolder '/' contents(i).name '/' images(j).name]));
        for k=1:nb_subimage
            name = images(j).name;
            name = name(1:end-4);
            if exist(['parameters/' contents(i).name '/' name '_' num2str(k) '.mat'], 'file') == 2
                continue;
            end
            [row_range, col_range] = extractSub(image, subimage_size); % need to change sub image extraction to range extraction
            [p, x, MSE] = interpParam(image, row_range, col_range, threshold, filter_len, method);
            param = {p, x, image(row_range, col_range, :), MSE};
            save(['parameters/' contents(i).name '/' name '_' num2str(k) '.mat'], 'param');
        end    
    end
end