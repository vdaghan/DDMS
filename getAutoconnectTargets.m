function autoconnectTargets = getAutoconnectTargets()
    autoconnectTargets = {};
    if (~isfile('autoconnectTargets.json'))
        autoconnectTarget = struct();
        userInput = input("Please enter server address (Leave blank for this computer):\n", "s");
        if (isempty(userInput))
            [~,hostname] = system('hostname');
            hostname = string(strtrim(hostname));
            autoconnectTarget.address = resolvehost(hostname,"address");
        elseif (strcmp("-", userInput))
            return;
        end
        autoconnectTarget.port = 6666;
        autoconnectTargets{1} = autoconnectTarget;
        jsontext = jsonencode(autoconnectTargets, PrettyPrint=true);
    
        fileID = fopen("autoconnectTargets.json", 'w');
        fprintf(fileID, jsontext);
        fclose(fileID);
    else
        jsontext = fileread('autoconnectTargets.json');
        autoconnectTargets = jsondecode(jsontext);
    end
end