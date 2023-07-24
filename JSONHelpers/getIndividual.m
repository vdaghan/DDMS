function individual = getIndividual(dataDirectory, id)
    individual = NaN;
    filename = dataDirectory + "\" + string(id.generation) + "\" + string(id.identifier) + ".deva";
    if ~isfolder(dataDirectory) || 0 == exist(filename, "file")
        return;
    end
    individual = getIndividualFromFile(filename);
end
