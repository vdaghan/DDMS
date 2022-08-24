function server = setupServer()
    [~,hostname] = system('hostname');
    hostname = string(strtrim(hostname));
    serverAddress = resolvehost(hostname,"address");
    server = tcpserver(serverAddress, 6666);
    configureCallback(server, "terminator", @bytesAvailableFunction);
    server.ConnectionChangedFcn = @(src, ~)connectionChangedFcn(true, src);
    server.Timeout = 3;
end