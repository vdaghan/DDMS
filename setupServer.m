function server = setupServer()
    [~,hostname] = system('hostname');
    hostname = string(strtrim(hostname));
    serverAddress = resolvehost(hostname,"address");
    server = tcpserver(serverAddress, 6666);
    configureCallback(server, "terminator", @bytesAvailableFunction);
    server.ConnectionChangedFcn = @serverConnectionChangedFcn;
    server.Timeout = 3;
    server.UserData = containers.Map();

    function serverConnectionChangedFcn(src, ~)
        connectionChangedFcn(true, src);
    end
end