function server = setupServer(target)
    fprintf("Setting up server as %s.\n", target.address);
    server = tcpserver(target.address, target.port);
    configureCallback(server, "terminator", @bytesAvailableFunction);
    server.ConnectionChangedFcn = @serverConnectionChangedFcn;
    server.Timeout = 3;
    server.UserData = containers.Map();
    server.UserData('packets') = containers.Map();

    function serverConnectionChangedFcn(src, ~)
        connectionChangedFcn(true, src);
    end
end