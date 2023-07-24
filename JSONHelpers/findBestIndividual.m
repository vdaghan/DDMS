function bestIndividual = findBestIndividual(dataDirectory, generation, metricName, direction)
    bestIndividualIdentifier = findBestIndividualIdentifier(dataDirectory, generation, metricName, direction);
    if ~isstruct(bestIndividualIdentifier)
        bestIndividual = NaN;
        return;
    end
    bestIndividual = getIndividual(dataDirectory, bestIndividualIdentifier);
end