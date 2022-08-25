function connectionChangedFcn(fromServer, src, ~)
    if src.Connected
        src.UserData('lastSeen') = datetime;
        src.UserData('address') = src.ClientAddress;
        src.UserData('connected') = true;
        src.UserData('port') = src.ClientPort;
        if (fromServer)
            src.UserData('type') = "client";
        else
            src.UserData('type') = "server";
        end
        display("Client " + src.ClientAddress + " is now connected.")
    else
        src.UserData('lastSeen') = datetime;
        src.UserData('connected') = false;
        display("Client " + src.ClientAddress + " is now disconnected.")
    end
end