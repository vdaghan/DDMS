function individual = getIndividual(dataDirectory, id)
    if ~isfolder(dataDirectory)
        individual = NaN;
        return;
    end
    jsonText = fileread(dataDirectory + "\" + string(id.generation) + "\" + string(id.identifier) + ".deva");
    individual = jsondecode(jsonText);
end
