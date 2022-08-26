classdef Node
    properties
        nodeProperties

        connectionType
        connectionAddress
        connectionPort
        connectionSocket
        connectionStatus

        sendQueue
        lastPacketId
    end

    methods
        function obj = Node(type, address)
            obj.sendQueue = containers.Map();
            obj.lastPacketId = -1;
            obj.nodeProperties = struct();
            obj.nodeProperties.affinity = -1;
            obj.connectionType = type;
            obj.connectionAddress = address;
            obj.connectionPort = 6666;
            obj.connectionStatus = 'uninitialised';
        end

        function obj = connect(obj)
            target = struct();
            target.address = obj.connectionAddress;
            target.port = obj.connectionPort;
            fprintf("Connecting to %s at %d.\n", target.address, target.port);
            obj.connectionStatus = 'connecting';
            if (strcmp('server', obj.connectionType))
                try
                    obj.connectionSocket = setupServer(target);
                catch
                    obj.connectionStatus = 'not_connected';
                    warning("Could not setup server at address " + target.address);
                end
            elseif (strcmp('client', obj.connectionType))
                try
                    obj.connectionSocket = setupClient(target);
                catch
                    obj.connectionStatus = 'not_connected';
                    warning("Could not connect to server at address " + target.address);
                end
            else
                obj.connectionStatus = 'error';
            end
            if strcmp(obj.connectionStatus, 'connecting')
                obj.connectionStatus = 'connected';
            end
        end

        function retVal = connected(obj)
            retVal = false;
            if (strcmp(obj.connectionStatus, "connected"))
                retVal = true;
            end
        end

        function retVal = hasData(obj)
            retVal = true;
            if ~obj.connected()
                retVal = false;
            elseif isempty(obj.connectionSocket.UserData)
                retVal = false;
            end
        end

        function data = popData(obj)
            data = obj.connectionSocket.UserData;
            obj.connectionSocket.UserData = containers.Map();
        end

        function p = getProperties(obj)
            p = obj.nodeProperties;
        end

        function obj = setProperties(obj, p)
            obj.nodeProperties = p;
        end

        function obj = queuePackedStruct(obj, packedStruct)
            obj.lastPacketId = obj.lastPacketId + 1;
            obj.sendQueue(obj.lastPacketId) = packedStruct;
        end

        function obj = trySendPackets(obj)
            if (~obj.connected())
                obj.connect();
                return;
            end
            for sendKeyCell = keys(obj.sendQueue)
                sendKey = sendKeyCell{1};
                byteStream = getByteStreamFromArray(obj.sendQueue(sendKey));
                writebinblock(obj.connectionSocket, byteStream, "uint8");
                % Error checking?
                remove(obj.sendQueue, sendKey);
            end
        end
    end
end