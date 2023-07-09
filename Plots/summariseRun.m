function summariseRun()
    jsontext = fileread('trackedDirectory.json');
    directory = jsondecode(jsontext);
    runDirectory = uigetdir([directory, '\..\'], 'Select a file');
    if ~isfolder(runDirectory)
        return;
    end
    clear jsontext directory;

    generations = getGenerations(runDirectory);
    for generation = generations
        generationInfos{generation+1} = getGenerationInfo(runDirectory, generation);
    end
    clear generation;

    plotSingleParetoFront(runDirectory, generations(end));
    plotParetoFront(runDirectory);

    figure('Name', 'Torques');
    tL = tiledlayout('flow');
    hold on;
    for generation = generations
        generationInfo = generationInfos{generation+1};

        for individualIdentifier = [generationInfo.newbornIdentifiers.identifier]
            indFileName = runDirectory + "\" + string(generation) + "\" + string(individualIdentifier) + ".deva";
            jsonText = fileread(indFileName);
            out = jsondecode(jsonText);
            torques = out.genotype.torque;
            torqueFields = fieldnames(torques);
            %tiledlayout(length(torqueFields),2);
            angles = out.phenotype.angles;
            angleFields = fieldnames(angles);
            for t = 1:length(torqueFields)
                nexttile(t);
                hold on;
                plot(torques.(torqueFields{t}), 'k')
                title([torqueFields{t} ' torques'])
            end
            for a = 1:length(angleFields)
                nexttile(length(torqueFields)+a);
                hold on;
                plot(angles.(angleFields{a})*360/(2*pi), 'k')
                title([angleFields{a} ' angles'])
            end
        end
    end

    hold off;
    drawnow limitrate;
end
