function [out, simulationInput] = simulateFromStruct(s)
    simulationInput = structToSimulationInput(s);
    
    load_system('handstand');
    warning('off','sm:sli:setup:compile:SteadyStateStartNotSupported');
    beep off;
    %out = sim(simulationInput, 'UseFastRestart', 'on');
    out = sim(simulationInput);
end
