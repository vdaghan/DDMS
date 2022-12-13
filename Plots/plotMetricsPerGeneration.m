function plotMetricsPerGeneration(dataDirectory, generation, metrics)
    generationInfo = getGenerationInfo(dataDirectory, generation);
    if ~isfield(generationInfo, 'survivorIdentifiers')
        return;
    end
    metricValues = [];
    for i = 1:length(generationInfo.survivorIdentifiers)
        individual = getIndividual(dataDirectory, generationInfo.survivorIdentifiers(i));
        metricValuesOfIndividual = [];
        for m = 1:length(metrics)
            metric = metrics(m);
            metricValue = individual.metricMap.(metric);
            metricValuesOfIndividual(1, m) = metricValue;
        end
        metricValues = [metricValues; metricValuesOfIndividual];
    end
    yyaxis left
    plot(metricValues(:, 1));
    yyaxis right
    plot(metricValues(:, 2));
end
