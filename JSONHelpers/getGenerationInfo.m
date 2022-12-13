function generationInfo = getGenerationInfo(dataDirectory, generation)
    if ~isfolder(dataDirectory)
        generationInfo = [];
        return;
    end
    jsonText = fileread(dataDirectory + "\" + string(generation) + "\state.gen");
    generationInfo = jsondecode(jsonText);
end
