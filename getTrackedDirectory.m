function trackedDirectory = getTrackedDirectory()
    if (~isfile('trackedDirectory.json'))
        trackedDirectory = "";
    else
        jsontext = fileread('trackedDirectory.json');
        trackedDirectory = jsondecode(jsontext);
    end
end