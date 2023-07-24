function plotOutputs(individual, outputNames)
    hold on;
    for outputName = outputNames
        output = individual.phenotype.outputs.(outputName);
        plot(output);
    end
    legend(outputNames)
end