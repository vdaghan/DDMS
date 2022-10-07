function out = simulateFromJSON(path)
    jsonObject = jsonFileToStruct(path);
    out = simulateFromStruct(jsonObject);
end