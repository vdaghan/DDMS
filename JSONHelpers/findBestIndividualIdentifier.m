function bestIndividualIdentifier = findBestIndividualIdentifier(dataDirectory, generation, metricName, direction)
    generationInfo = getGenerationInfo(dataDirectory, generation);
    bestIndividualIdentifier = NaN;
    if isfield(generationInfo, 'survivorIdentifiers')
        identifiers = generationInfo.survivorIdentifiers;
        numIdentifiers = length(identifiers);
        values = nan(1, numIdentifiers);
        parfor j = 1:numIdentifiers
            individual = getIndividual(dataDirectory, identifiers(j));
            if ~isstruct(individual)
                continue;
            end
            values(j) = individual.metricMap.(metricName);
        end
        [~, indices] = sort(values, direction, 'MissingPlacement', 'last');
        bestIndividualIdentifier = identifiers(indices(1));
    end
end