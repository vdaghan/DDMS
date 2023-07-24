function out = simulateIndividualFromFile(filename, model)
    if ~isfile(filename)
        return;
    end
    jsonText = fileread(filename);
    in = jsondecode(jsonText);
    simin = in.genotype;
    simin.alignment = [0, simin.alignment; eps, -1];
    [out, ~] = simulateFromStruct(simin, model);
end