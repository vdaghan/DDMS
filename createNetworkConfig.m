if (~isfile('networkConfig.json'))
    networkConfig = struct();
    networkConfig.serverAddress = input("Please enter server address (Leave blank for this computer):\n", "s");
    if (isempty(networkConfig.serverAddress))
        [~,hostname] = system('hostname');
        hostname = string(strtrim(hostname));
        networkConfig.serverAddress = resolvehost(hostname,"address");
        clear hostname;
    end
    networkConfig.serverPort = 6666;
    jsontext = jsonencode(networkConfig, PrettyPrint=true);

    fileID = fopen("networkConfig.json", 'w');
    fprintf(fileID, jsontext);
    fclose(fileID);
    clear jsontext serverAddress fileID;
else
    jsontext = fileread('networkConfig.json');
    networkConfig = jsondecode(jsontext);
    clear jsontext;
end