function projects = findProjects()
    projects = containers.Map();
    if (~exist("./projects", "file"))
        mkdir("projects");
        return;
    end
    projectFolders = dir("./projects");
    projectFolders = projectFolders([projectFolders.isdir]);
    projectFolders = projectFolders(~strcmp('.', {projectFolders.name}));
    projectFolders = projectFolders(~strcmp('..', {projectFolders.name}));
    projectFolders = {projectFolders.name};
    for projectFolder = projectFolders
        projectName = projectFolder{1};
        project = containers.Map();
        project('name') = projectName;
        projectModelFile = "./projects/" + projectName + "/" + projectName + ".slx";
        if (exist(projectModelFile, "file"))
            project('modelFile') = projectModelFile;
            project('modelChecksum') = Simulink.getFileChecksum(projectModelFile);
        end
        projects(projectName) = project;
    end
end
