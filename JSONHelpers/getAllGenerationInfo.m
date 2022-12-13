function generationInfo = getAllGenerationInfo(dataDirectory)
    generations = getGenerations(dataDirectory);
    for generation = generations
        tmp_generationInfo = getGenerationInfo(dataDirectory, generation);
        generationInfo{generation + 1} = tmp_generationInfo;
    end
end
