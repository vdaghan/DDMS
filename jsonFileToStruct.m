function out = jsonFileToStruct(path)
    jsonText = fileread(path);
    out = jsondecode(jsonText);
    out.alignment = [0, out.alignment; eps, -1];
end