clc;
clear;
init;
runPath = uigetdir;
dataDir = runPath + "\data";
matFileName = runPath + "\data.mat";
m = matfile(matFileName,'Writable',true);
currentDir = pwd;
% cd(runPath);

% m.Properties.Writable = true;
allGenInfo = getAllGenerationInfo(dataDir);
generations = getGenerations(dataDir);
individualIndices = containers.Map('KeyType','char','ValueType','any');

maxIndividual = -1;
for genInfo = allGenInfo
    generationInfo = genInfo{1};
    if isfield(generationInfo, 'newbornIdentifiers')
        numNewborns = length(generationInfo.newbornIdentifiers);
        for j = 1:numNewborns
            identifier = generationInfo.newbornIdentifiers(j);
            if identifier.identifier > maxIndividual
                maxIndividual = identifier.identifier;
            end
        end
    end
end

m.allGenerations = allGenInfo;
%%
m.otherData = import(generations, dataDir, "other");
m.genotypes = import(generations, dataDir, "genotype");
m.phenotypes = import(generations, dataDir, "phenotype");

function imported = import(generations, dataDir, importType)
    imported = containers.Map('KeyType','char','ValueType','any');
    if ~isempty(generations)
        wb = waitbar(0,'Please wait...');
        gen = 0;
        
        for generation = generations
            progress = gen/(length(generations));
            waitbar(progress, wb, sprintf('Importing generation %d of %d (%3.2f percent complete)', gen, length(generations), 100*progress));
            generationInfo = getGenerationInfo(dataDir, generation);
            if isfield(generationInfo, 'newbornIdentifiers')
                numNewborns = length(generationInfo.newbornIdentifiers);
                for j = 1:numNewborns
                    individual = getIndividual(dataDir, generationInfo.newbornIdentifiers(j));
                    if isstruct(individual)
                        identifier = identifierToChar(individual.identifier);
                        imported(identifier) = importIndividualParts(individual, importType);
                    end
                end
            end
            gen = gen + 1;
        end
    end
end

function imported = importIndividualParts(individual, importType)
    if strcmp(importType, "other")
        imported = rmfield(individual, {'genotype', 'phenotype'});
    elseif strcmp(importType, "genotype")
        imported = individual.genotype;
    elseif strcmp(importType, "phenotype")
        imported = individual.phenotype;
    end
end

function identifierAsChar = identifierToChar(identifier)
    identifierAsChar = string(identifier.generation) + "_" + string(identifier.identifier);
end