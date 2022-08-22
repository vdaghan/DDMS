clear client;
clear server;

[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
address = resolvehost(hostname,"address");
%address = "127.0.0.1";


server = tcpserver(address, 6666, "ConnectionChangedFcn", @connectionFcn);
configureCallback(server, "byte", 7688, @readDataFcn);
client = tcpclient(server.ServerAddress, server.ServerPort, "Timeout", 5);
pause(1);

rawData = read(client,961,"double");
reshapedData = reshape(rawData, 31, 31);
surf(reshapedData);

write(client, rawData, "double");



%write(server,"hello world","string");
%read(client,11,"string");


clear client;
clear server;

function connectionFcn(src, ~)
    if src.Connected
        disp("Client connection accepted by server.")
        data = membrane(1);
        write(src, data(:), "double");
    end
end

function readDataFcn(src, ~)
    disp("Data was received from the client.")
    src.UserData = read(src, src.BytesAvailableFcnCount/8, "double");
    reshapedServerData = reshape(src.UserData, 31, 31);
    surf(reshapedServerData);
end