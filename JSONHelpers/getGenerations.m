function generations = getGenerations(dataDirectory)
    foldersInDirectory = dir(dataDirectory);
    foldersInDirectory = foldersInDirectory([foldersInDirectory.isdir]);
    foldersInDirectory = foldersInDirectory(~isnan(str2double({foldersInDirectory.name})));
    generations = str2double({foldersInDirectory.name});
    generations = sort(generations);
end
