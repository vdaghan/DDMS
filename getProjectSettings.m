function projectSettings = getProjectSettings(projectName)
% projectSettings has these fields:
% .name = project name
% .haveModel = do we have model file?
% .checksum = project model checksum
    projectSettings = struct();
    projectSettings.name = projectName;
    projectFolder = "./projects/" + projectName;
    projectSettings.projectFolder = projectFolder;
    if ~exist(projectFolder, 'file')
        mkdir(projectFolder);
        projectSettings.haveModel = false;
        return;
    end
    simulationFile = projectFolder + "/" + projectName + ".slx";
    if ~exist(simulationFile, 'file')
        projectSettings.haveModel = false;
        return;
    end
    projectSettings.haveModel = true;
    projectSettings.simulationFile = getByteStreamFromArray(simulationFile);
    projectSettings.checksum = Simulink.getFileChecksum(simulationFile);
end