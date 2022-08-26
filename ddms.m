clc;
clear;

nodeMap = containers.Map();

properties = collectProperties();
projects = findProjects();
projectSettings = getProjectSettings('handstand');
localAddress = getLocalAddress();
server = Node('server', localAddress);
server.connect();

simulationQueue = SimulationQueue();
simulationInputs = containers.Map();
simulationOutputs = containers.Map();
outgoingPackets = containers.Map();

autoconnectTargets = getAutoconnectTargets();
for target = autoconnectTargets
    nodeMap(target.address) = Node('client', target.address);
end

loop = true;
while (loop)
    % Process incoming packets
    for keyCell = keys(nodeMap)
        key = keyCell{1};
        if (~nodeMap(key).connected())
            continue;
        end
        if (~nodeMap(key).hasData())
            continue;
        end
        userData = nodeMap(key).popData();
        for userDataKeyCell = keys(userData)
            userDataKey = userDataKeyCell{1};
            packet = userData(userDataKey);
            if (strcmp("simulationInput", packet.type))
                simulationQueue.push(packet.id, packet.value);
            elseif (strcmp("simulationOutput", packet.type))
                simulationOutputs(packet.id) = packet.value;
            elseif (strcmp("project", packet.type))
                projectSettings = packet.value;
            elseif (strcmp("properties", packet.type))
                nodeMap(key).properties = packet.value;
            else
                warning("Can't handle packet of type " + packet.type);
                continue;
            end
            clear userData;
        end
    end

    % Update affinity
    updatedAffinity = properties.affinity;
    for keyCell = keys(nodeMap)
        key = keyCell{1};
        nodeProperties = nodeMap(key).getProperties();
        nodeAffinity = nodeProperties.affinity;
        if -1 == nodeAffinity
            continue;
        elseif nodeAffinity + 1 < updatedAffinity
            updatedAffinity = nodeAffinity + 1;
        end
    end
    if updatedAffinity < properties.affinity
        properties.affinity = updatedAffinity;
        for keyCell = keys(nodeMap)
            key = keyCell{1};

            outgoingPacket = struct();
            outgoingPacket.type = 'properties';
            outgoingPacket.value = properties;

            nodeMap(key).queuePackedStruct(outgoingPacket);
        end
    end

    % Send outgoing packets
    for keyCell = keys(nodeMap)
        key = keyCell{1};
        nodeMap(key).trySendPackets();
    end

    % Distribute simulation inputs

    % Do some simulation

    %loop = false;
    fprintf(".");
    pause(0.2);
end
