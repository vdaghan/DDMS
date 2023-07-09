function plotSingleParetoFront(dataDirectory, generation)
    generationInfo = getGenerationInfo(dataDirectory, generation);
    gcf;
    hold on;
%     if isfield(generationInfo, 'elderIdentifiers')
%         point = [];
%         for j = 1:length(generationInfo.elderIdentifiers)
%             individual = getIndividual(dataDirectory, generationInfo.elderIdentifiers(j));
%             point(end+1, :) = [individual.metricMap.fitness, individual.metricMap.balance];
%         end
%         scatter(point(:, 1), point(:, 2), 5, 'k', 'filled');
%     end
%     if isfield(generationInfo, 'newbornIdentifiers')
%         point = [];
%         for j = 1:length(generationInfo.newbornIdentifiers)
%             individual = getIndividual(dataDirectory, generationInfo.newbornIdentifiers(j));
%             point(end+1, :) = [individual.metricMap.fitness, individual.metricMap.balance];
%         end
%         scatter(point(:, 1), point(:, 2), 5, 'k', 'filled');
%     end
    if isfield(generationInfo, 'survivorIdentifiers')
        frontLine = [];
        for j = 1:length(generationInfo.survivorIdentifiers)
            individual = getIndividual(dataDirectory, generationInfo.survivorIdentifiers(j));
            frontLine(end+1, :) = [individual.metricMap.fitness, individual.metricMap.balance];
        end
        scatter(frontLine(:, 1), frontLine(:, 2), 5, 'r', 'filled');
        plot(frontLine(:, 1), frontLine(:, 2), 'r');
    end
    hold off;
end
