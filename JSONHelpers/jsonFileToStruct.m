function out = jsonFileToStruct(path)
    if ~isfile(path)
        out = [];
        return;
    end
    jsonText = fileread(path);
    out = jsondecode(jsonText);
    out.alignment = [0, out.alignment; eps, -1];
    %out.alignment = [0, 0; eps, -1];
end