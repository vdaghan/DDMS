clc;
clear;

init;
runPath = uigetdir;
dataDir = runPath + "\data";
tic;
allGenInfo = getAllGenerationInfo(dataDir);
generations = getGenerations(dataDir);
toc;
lastGen = length(allGenInfo)-1;

metricMaps = {};
tic;
if ~isempty(generations)
    wb = waitbar(0,'Please wait...');
    gen = 1;
    for generation = generations
        progress = gen/(length(generations));
        waitbar(progress, wb, sprintf('Importing generation %d of %d (%3.2f percent complete)', gen, length(generations), 100*progress));

        generationInfo = getGenerationInfo(dataDir, generation);
        generationMetricMaps = [];
        if isfield(generationInfo, 'newbornIdentifiers')
            numNewborns = length(generationInfo.newbornIdentifiers);
            for j = 1:numNewborns
                individual = getIndividual(dataDir, generationInfo.newbornIdentifiers(j));
                if ~isstruct(individual)
                    continue;
                end
                if individual.metricMap.fitness < 0
                    continue;
                end
                generationMetricMaps = [generationMetricMaps, individual.metricMap];
            end
        end
        metricMaps{end+1} = generationMetricMaps;
        gen = gen + 1;
%         if gen == 50
%             break
%         end
    end
end
toc;

clear fns;
for metricMap = metricMaps
    fn = string(fieldnames(metricMap{1}));
    if exist('fns', 'var')
        fns = union(fn, fns);
    else
        fns = fn;
    end
end

%%
minimums = containers.Map;
maximums = containers.Map;
for i = 1:length(fns)
    fn = fns(i);
    minimums(fn) = realmax;
    maximums(fn) = realmin;
end
clear i fn;
for metricMap = metricMaps
    for i = 1:length(fns)
        fn = fns(i);
        mm = metricMap{1};
        tmp = min([mm.(fn)]);
        if tmp < minimums(fn)
            minimums(fn) = tmp;
        end
        tmp = max([mm.(fn)]);
        if tmp > maximums(fn)
            maximums(fn) = tmp;
        end
    end
end
clear i fn mm tmp;

allMetricMaps = [];
for mm = metricMaps
    allMetricMaps = [allMetricMaps, mm{1}];
end

clear stepSizes;
stepSizes.balance = 16;
stepSizes.fitness = 16;
%stepSizes = [64, 128];
for i = 1:length(fns)
    fn = fns(i);
    minimum = minimums(fn);
    maximum = maximums(fn);
    stepSize = stepSizes.(fn);

    step = (maximum-minimum)/(stepSize-1);
    edges = minimum:step:maximum;
    colormap = (1:-1/(stepSize-2):0)' .* [1,1,1];

    hc = nan(length(edges)-1, length(metricMaps));
    for j = 1:length(metricMaps)
        v = metricMaps(j);
        v = [v{1}.(fn)];
        [hc(:, j), ~] = histcounts(v, edges);
    end
    
    figure;
    heatmap(hc, ...
        'ColorMethod', 'count', ...
        'GridVisible', 'off', ...
        'YDisplayLabels', string(edges(1:end-1)), ...
        'MissingDataColor', [0 0 0], ...
        'Colormap', colormap);
    figure;
    mm = [metricMaps{2}.(fn)];
    mm = histcounts(mm, edges);
    heatmap(mm', ...
        'ColorMethod', 'count', ...
        'GridVisible', 'off', ...
        'YDisplayLabels', string(edges(1:end-1)), ...
        'MissingDataColor', [0 0 0], ...
        'Colormap', colormap);
    figure;
    a = [allMetricMaps.(fn)];
    a = [metricMaps{2}.(fn)];
    histogram(a, edges);
end
% figure;
% histogram(allMetricMaps(:, end), stepSize);

clear i j fn stepSize step edges colormap hc v;
