function client = setupClient(target)
    client = tcpclient(target.address, target.port, "Timeout", 5);
    configureCallback(client, "terminator", @bytesAvailableFunction);
    client.ErrorOccurredFcn = @errorOccurredFcn;
    client.Timeout = 3;
    client.UserData = containers.Map();
    client.UserData('packets') = containers.Map();
end