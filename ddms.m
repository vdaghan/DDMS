clc;
clear;

% TODO: zip tracked folder as we process them

nodeMap = containers.Map();

properties = collectProperties();
projects = findProjects();
projectSettings = getProjectSettings('handstand');
localAddress = getLocalAddress();
inputTracker = InputTracker();
server = Node('server', localAddress);
server.connect();

simulationQueue = SimulationQueue();
resultQueue = SimulationQueue();
outgoingPackets = containers.Map();

autoconnectTargets = getAutoconnectTargets();
for target = autoconnectTargets
    nodeMap(target.address) = Node('client', target.address);
end

loop = true;
while (loop)
    % Track inputs if there is any
    if inputTracker.tracks()
        inputTracker = inputTracker.update(); % This is stupid...
        [inputTracker, simIDList] = inputTracker.reserveFilesToProcess(-1);
        if ~isempty(simIDList)
            for simID = simIDList
                simulationObject = inputTracker.decodeSimulationInput(simID);
                simulationInput = Simulink.SimulationInput(projectSettings.name);
                simulationInput = simulationInput.setVariable('simulationId', simID); % This is stupid...
                simulationInput = simulationInput.setModelParameter('TimeOut', simulationObject.timeout); % This is stupid...
                fnames = fieldnames(simulationObject);
                for findex = 1:length(fnames)
                    fieldName = fnames{findex};
                    simulationInput = simulationInput.setVariable(fieldName, simulationObject.(fieldName)); % This is stupid...
                end
                simulationQueue.push(simID, simulationInput);
            end
        end
    end
    
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
    
    % Collect simulation inputs

    % Distribute simulation inputs

    % Do some simulation and record outputs
    simulationInputs = simulationQueue.pop(properties.numCores * 5);
    %simulationInputs = simulationQueue.pop(-1);
    if ~isempty(simulationInputs)
        simulationOutputs = parsim([simulationInputs{:}]);
        for i = 1:length(simulationOutputs)
            simID = simulationInputs{i}.Variables(1).Value;
            resultQueue.push(simID, simulationOutputs(i));
        end
    end
    
    % Track inputs if there is any
    if inputTracker.tracks()
        while ~resultQueue.isempty()
            [data, id] = resultQueue.pop();
            inputTracker.encodeSimulationOutput(id, data{1});
        end
    end

    %loop = false;
    fprintf(".");
    pause(0.2);
end
