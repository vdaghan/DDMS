function out = importIndividualFromFile()
    jsontext = fileread('trackedDirectory.json');
    directory = jsondecode(jsontext);
    [fileName, path] = uigetfile({'*.deva';'*.in'}, 'Select a file', directory);
    path = [path, fileName];
    if ~isfile(path)
        return;
    end
    jsonText = fileread(path);
    out = jsondecode(jsonText);
    simin = out.genotype;
    simin.alignment = [0, simin.alignment; eps, -1];

    torques = out.genotype.torque;
    torqueFields = fieldnames(torques);
    torqueSplines = out.genotype.torqueSplines;
    angles = out.phenotype.angles;
    angleFields = fieldnames(angles);
    figure('Name', fileName);
    tiledlayout(length(torqueFields),2);
    for t = 1:length(torqueFields)
        nexttile(1+2*(t-1));
        hold on;
        plot(torques.(torqueFields{t}));
        torqueSpline = torqueSplines.(torqueFields{t});
        splineIndices = [torqueSpline.index]+1;
        splineValues = [torqueSpline.value]; 
        scatter(splineIndices, splineValues, ones(length(splineIndices)) * 10, 'red');
        title([torqueFields{t} ' torques'])
        hold off;
    end
    for a = 1:length(angleFields)
        nexttile(2+2*(a-1));
        plot(angles.(angleFields{a})*360/(2*pi))
        title([angleFields{a} ' angles'])
    end
end