clear server;
global clientMap;

createNetworkConfig;
clientMap = containers.Map();

server = tcpserver(networkConfig.serverAddress, networkConfig.serverPort, "ConnectionChangedFcn", @connectionFcn);
%configureCallback(server, "byte", 7688, @readDataFcn);

while (true)
    if (isempty(clientMap))
        pause(3);
        continue;
    end
    for key = keys(clientMap)
        client = clientMap(string(key));
        infoToCheck = [["cores"; "uint8"], ["bench"; "double"], ["version"; "string"]];
        for command = infoToCheck
            if (~isKey(client, command(1)))
                writeline(server, command(1));
                result = readbinblock(server, command(2));
                client(command(1)) = result;
                if (~isempty(result))
                    display("Client " + client("address") + " states " + command(1) + " = " + string(result));
                end
            end
        end
    end
    pause(1);
end


function connectionFcn(src, ~)
    global clientMap;
    if src.Connected
        client = containers.Map();
        client('address') = src.ClientAddress;
        client('connected') = src.Connected;
        client('port') = src.ClientPort;
        clientMap(src.ClientAddress) = client;
        display("Client " + src.ClientAddress + " is now connected.")
    else
        remove(clientMap, src.ClientAddress);
        display("Client " + src.ClientAddress + " is now disconnected.")
    end
end