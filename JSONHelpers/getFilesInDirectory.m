function files = getFilesInDirectory(directory, extension)
%     files = containers.Map;
%     filesInDirectory = dir(directory);
%     filesInDirectory = filesInDirectory(~[filesInDirectory.isdir]);
%     for extension = extensions
%         filesInDirectoryWithExtension = filesInDirectory(endsWith({filesInDirectory.name}, extension));
%         fileNamesInDirectory = {};
%         if (~isempty(filesInDirectoryWithExtension))
%             filesInDirectoryWithExtension = {filesInDirectoryWithExtension.name};
%             fileNamesInDirectory = [fileNamesInDirectory, filesInDirectoryWithExtension];
%             files(extension) = fileNamesInDirectory;
%         end
%     end
    filesInDirectory = dir(directory);
    filesInDirectory = filesInDirectory(~[filesInDirectory.isdir]);
    filesInDirectory = filesInDirectory(endsWith({filesInDirectory.name}, extension));
    fileNamesInDirectory = {};
    if (~isempty(filesInDirectory))
        fileNamesInDirectory = {filesInDirectory.name};
    end
    files = fileNamesInDirectory;
end
