clc;
clear;

clientMap = containers.Map();

benchmarkResult = getBenchmarkResult();
projects = findProjects();
server = setupServer();

autoconnectTargets = getAutoconnectTargets();
for target = autoconnectTargets
    clientMap(target.address) = setupClient(target);
end

loop = true;
while (loop)
    for key = keys(clientMap)
        clientData = clientMap(key{1}).UserData;
    end
    loop = false;
end
