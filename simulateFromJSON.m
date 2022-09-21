function simulateFromJSON(path)
    jsonText = fileread(path);
    jsonObject = jsondecode(jsonText);

    simulationInput = Simulink.SimulationInput("handstand");
    simulationInput = simulationInput.setVariable('simulationId', 0); % This is stupid...
    fnames = fieldnames(jsonObject);
    for findex = 1:length(fnames)
        fieldName = fnames{findex};
        simulationInput = simulationInput.setVariable(fieldName, jsonObject.(fieldName)); % This is stupid...
    end
    
    load_system('handstand');
    warning('off','sm:sli:setup:compile:SteadyStateStartNotSupported');
    sim(simulationInput, 'UseFastRestart', 'on');
end