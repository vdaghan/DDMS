init;
runPath = uigetdir;
dataDir = runPath + "\data";
allGenInfo = getAllGenerationInfo(dataDir);
generations = getGenerations(dataDir);
lastGen = length(allGenInfo)-1;

tic;
figure;
plotSingleParetoFront(dataDir, lastGen, ["survivors"]);
xlabel("Ağırlık Merkezinin Ortalama Yüksekliği (m)")
ylabel("Ağırlık Merkezinin Denge Konumuna Ortalama Uzaklığı (m)")
title(string(lastGen) + ". Nesil Pareto Cephesi")
toc;

tic;
figure;
plotSingleParetoFront(dataDir, lastGen, ["newborns", "survivors"]);
xlabel("Ağırlık Merkezinin Ortalama Yüksekliği (m)")
ylabel("Ağırlık Merkezinin Denge Konumuna Ortalama Uzaklığı (m)")
title(string(lastGen) + ". Nesil Pareto Cephesi")
toc;

tic;
figure;
plotMetricsPerGeneration(dataDir, lastGen, ["fitness", "balance"]);
xlabel("Birey")
ylabel("Ağırlık Merkezinin Ortalama Yüksekliği (m)")
ylabel("Ağırlık Merkezinin Denge Konumuna Ortalama Uzaklığı (m)")
title(string(lastGen) + ". Nesil Ölçek Değerleri")
toc;

tic;
figure;
plotParetoFront(dataDir, ["newborns", "survivors"]);
xlabel("Ağırlık Merkezinin Ortalama Yüksekliği (m)")
ylabel("Ağırlık Merkezinin Denge Konumuna Ortalama Uzaklığı (m)")
title("Bütün Bireylerin Pareto Cepheye Göre Konumlanışları")
toc;

tic;
if ~isempty(generations)
    numGens = length(generations);
    meanTimes = zeros(1, numGens);
    numNegatives = zeros(1, numGens);
    numPositives = zeros(1, numGens);
    timesPerGeneration = zeros(1, numGens);
    parfor generation = generations
        generationInfo = getGenerationInfo(dataDir, generation);
        if isfield(generationInfo, 'newbornIdentifiers')
            numNewborns = length(generationInfo.newbornIdentifiers);
            numNegativesInGeneration = nan(1, numNewborns);
            numPositivesInGeneration = nan(1, numNewborns);
            generationTimes = nan(1, numNewborns);
            for j = 1:numNewborns
                individual = getIndividual(dataDir, generationInfo.newbornIdentifiers(j));
                if ~isstruct(individual)
                    continue;
                end
                generationTimes(j) = individual.phenotype.metadata.totalTime;
                numNegativesInGeneration(j) = individual.metricMap.fitness < 0;
                numPositivesInGeneration(j) = individual.metricMap.fitness >= 0;
            end
            meanTimes(generation + 1) = mean(generationTimes, "omitnan");
            timesPerGeneration(generation + 1) = sum(generationTimes, "omitnan");
            numNegatives(generation + 1) = sum(numNegativesInGeneration, "omitnan");
            numPositives(generation + 1) = sum(numPositivesInGeneration, "omitnan");
        end
    end
end
figure;
plot(meanTimes)
xlabel("Nesil")
ylabel("Ortalama Benzeşim Süresi (sn)")
title("Ortalama Benzeşim Süreleri")

figure;
plot(timesPerGeneration)
xlabel("Nesil")
ylabel("Toplam Benzeşim Süresi (sn)")
title("Toplam Benzeşim Süreleri")

figure;
area([numPositives', numNegatives'])
axis tight;
ylabel("Birey Sayısı")
xlabel("Nesil")
legend({'Pozitif Yüksekliğe Sahip Bireyler', 'Negatif Yüksekliğe Sahip Bireyler'})
title("Yükseklik Değerine Göre Birey Sayısı")

totalTime = sum(timesPerGeneration, "omitnan");
toc;

bestIndividual = findBestIndividual(dataDir, 1023, "fitness", 'descend');
worstIndividual = findBestIndividual(dataDir, 1023, "fitness", 'ascend');

plotIndividualTorques(bestIndividual, figure, figure);

plotIndividualTorques(worstIndividual, figure, figure);

% figure;
% hold on;
% yyaxis left;
% plot(bestIndividual.genotype.time, calculateFitness(bestIndividual, "centerOfMassZ"), 'k');
% ylabel("Ağırlık Merkezinin Yüksekliği (m)");
% yyaxis right;
% plot(bestIndividual.genotype.time, calculateBalance(bestIndividual), 'k--');
% xlabel("Zaman (s)");
% ylabel("Denge Konumuna Uzaklık (m)");
% title("Ağırlık merkezine göre eniyileştirilmiş bireyin ölçekleri");
% legend(["Ağırlık Merkezinin Yüksekliği (m)", "Denge Konumuna Uzaklık (m)"], 'Location', 'northwest')
% hold off;

[standstillfile, standstillpath] = uigetfile("*.deva", "Select standstill motion file", runPath);
standstillfile = [standstillpath, standstillfile];
if 0 ~= standstillfile
    standstillIndividual = getIndividualFromFile(standstillfile);

    plotIndividualTorques(standstillIndividual, figure, figure);
end
