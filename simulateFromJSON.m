function out = simulateFromJSON(path)
    jsonObject = jsonFileToStruct(path);
    simulationInput = structToSimulationInput(jsonObject);
    
    load_system('handstand');
    warning('off','sm:sli:setup:compile:SteadyStateStartNotSupported');
    beep off;
    out = sim(simulationInput, 'UseFastRestart', 'on');
end