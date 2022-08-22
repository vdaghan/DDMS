clear client;

createBenchmarkConfig;
createNetworkConfig;

client = tcpclient(networkConfig.serverAddress, networkConfig.serverPort, "Timeout", 5);
while (true)
    command = readline(client);
    if (isempty(command))
        pause(1)
    elseif ("cores" == command)
        writebinblock(client, maxNumCompThreads, "uint8");
    elseif ("bench" == command)
        writebinblock(client, benchmark.ODE, "double");
    elseif ("version" == command)
        writebinblock(client, version, "string");
    end
    pause(3);
end
