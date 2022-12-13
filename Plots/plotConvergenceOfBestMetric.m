function plotConvergenceOfBestMetric(dataDirectory, generation, metric)
    generationInfo = getGenerationInfo(dataDirectory, generation);
    convergence = {};
    if isfield(generationInfo, 'survivorIdentifiers')
        individual = getIndividual(dataDirectory, generationInfo.survivorIdentifiers(1));
        convergence{1} = individual;
        parents = getParents(dataDirectory, individual);
        convergence{2} = parents;
        for parent = parents
            grandparents = getParents(dataDirectory, parent);
            convergence{3} = grandparents;
            for grandparent = grandparents
                grandgrandparents = getParents(dataDirectory, grandparent);
                convergence{4} = grandgrandparents;
            end
        end
    end
end

