function bytesAvailableFunction(src, ~)
    global clientMap;
    clientMap(src.ClientAddress).('lastSeen') = datetime;
    command = readbinblock(src, "string");
    if (isempty(command))
        return;
    end
    if ("cores" == command)
        writebinblock(src, maxNumCompThreads, "uint8");
    elseif ("bench" == command)
        writebinblock(client, benchmark.ODE, "double");
    end
end