function out = simulateFromJSON(path)
    jsonText = fileread(path);
    jsonObject = jsondecode(jsonText);
    out = simulateFromStruct(jsonObject);
end