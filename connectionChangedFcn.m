function connectionChangedFcn(fromServer, src, ~)
    global clientMap;
    if src.Connected
        client = containers.Map();
        client('lastSeen') = datetime;
        client('address') = src.ClientAddress;
        client('connected') = true;
        client('port') = src.ClientPort;
        if (fromServer)
            client('type') = "client";
        else
            client('type') = "server";
        end
        clientMap(src.ClientAddress) = client;
        display("Client " + src.ClientAddress + " is now connected.")
    else
        client = clientMap(src.ClientAddress);
        client('lastSeen') = datetime;
        client('connected') = false;
        clientMap(src.ClientAddress) = client;
        display("Client " + src.ClientAddress + " is now disconnected.")
    end
end