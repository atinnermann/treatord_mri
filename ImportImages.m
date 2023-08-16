function t = ImportImages(t,expPath)

t.pics.path = fullfile(expPath,'FreqStims'); %Ordner
files = dir(t.pics.path);
files = char(files.name);

for i = 1:size(files)
    ind(i) = endsWith(deblank(files(i,:)),'.png');
end

t.pics.files = files(ind,:);

t.pics.block = []; t.pics.noTreat = []; t.pics.lowTreat = []; t.pics.medTreat = []; t.pics.highTreat = [];
for j = 1:size(t.pics.files,1)
    if startsWith(t.pics.files(j,:),'0')
        t.pics.block = [t.pics.block; t.pics.files(j,:)];
    elseif startsWith(t.pics.files(j,:),'1')
        t.pics.noTreat = [t.pics.noTreat; t.pics.files(j,:)];
    elseif startsWith(t.pics.files(j,:),'2')
        t.pics.lowTreat = [t.pics.lowTreat; t.pics.files(j,:)];
    elseif startsWith(t.pics.files(j,:),'3') 
        t.pics.medTreat = [t.pics.medTreat; t.pics.files(j,:)];
    elseif startsWith(t.pics.files(j,:),'4')
        t.pics.highTreat = [t.pics.highTreat; t.pics.files(j,:)];
    end
end
       