function server = setupServer(serverAddress)
    server = tcpserver(serverAddress, 6666);
    configureCallback(server, "terminator", @bytesAvailableFunction);
    server.ConnectionChangedFcn = @serverConnectionChangedFcn;
    server.Timeout = 3;
    server.UserData = containers.Map();
    server.UserData('packets') = containers.Map();

    function serverConnectionChangedFcn(src, ~)
        connectionChangedFcn(true, src);
    end
end