clc;
clear;

clientMap = containers.Map();

benchmarkResult = getBenchmarkResult();
projects = findProjects();
server = setupServer();

autoconnectTargets = getAutoconnectTargets();
for target = autoconnectTargets
    client = tcpclient(target.address, target.port, "Timeout", 5);
    clientMap(client.Address) = client;
end
