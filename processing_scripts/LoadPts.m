function pts = LoadPts(ptsPath)
% Read points from a landmark annotation file 
% ptsPath: the landmark annotation path such as '300VW/114/annot/000001.pts'

% Read the file
fPts = fopen(ptsPath);
fileContent = [];
while true
    line = fgetl(fPts);
    if line == -1
        break
    else
        fileContent = horzcat(fileContent, ' ', line);
    end
end
fclose(fPts);

% How many points?
found = strfind(fileContent, 'n_points');
fileContent = fileContent(found(1) + 8 : end);
found = find(fileContent == ':');
fileContent = fileContent(found(1) + 1 : end);
pts = zeros(sscanf(fileContent, '%d'), 2);

% Get the points
found = find(fileContent == '{');
fileContent = fileContent(found(1) + 1 : end);
found = find(fileContent == '}');
fileContent = fileContent(1 : found(1) - 1);
coords = sscanf(fileContent, '%f ');
pts(:, 1) = coords(1 : 2 : end);
pts(:, 2) = coords(2 : 2 : end);

end
