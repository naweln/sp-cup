% script to count the CFA type found for each model, to test if it actually
% carries valuable information

startFolder = pwd;
paramFolder = './parameters/';

cd(paramFolder);
models = dir;
model_bool = zeros(numel(models),1);
for i=1:numel(models)
    model_bool(i) = isempty(strfind(models(i).name, '.'));
end

i = 1;
while i <= numel(models)
    if model_bool(i) == 0
        models(i) = [];
        model_bool(i) = [];
    else
        i = i+1;
    end
end

cd(startFolder);
[~,p_space] = patternCFA(0);
matrix = zeros(length(models),p_space);
for i=1:length(models)
   cd([paramFolder models(i).name]);
   data = dir('*.mat');
   cd(startFolder);
   for j=1:length(data);
       cd([paramFolder models(i).name]);
       load(data(j).name)
       cd(startFolder);
       for k=1:p_space
           if param{1} == patternCFA(k)
                matrix(i,k) = matrix(i,k) + 1;
           end
       end
   end
end

cd(startFolder);