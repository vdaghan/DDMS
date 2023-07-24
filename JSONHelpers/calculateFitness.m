function fitness = calculateFitness(individual, outputName)
    fitness = individual.phenotype.outputs.(outputName);
end