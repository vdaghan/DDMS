function plotParetoFront(dataDirectory)
    generations = getGenerations(dataDirectory);
    if isempty(generations)
        return;
    end
    
    f = figure;
    hold on;
    for generation = generations
        plotSingleParetoFront(dataDirectory, generation);
    end
    hold off;
end
