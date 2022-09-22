function out = simulateFromStruct(obj)
    simulationInput = Simulink.SimulationInput("handstand");
    simulationInput = simulationInput.setVariable('simulationId', 0); % This is stupid...
    fnames = fieldnames(obj);
    for findex = 1:length(fnames)
        fieldName = fnames{findex};
        simulationInput = simulationInput.setVariable(fieldName, obj.(fieldName)); % This is stupid...
    end
    
    load_system('handstand');
    warning('off','sm:sli:setup:compile:SteadyStateStartNotSupported');
    beep off;
    out = sim(simulationInput, 'UseFastRestart', 'on');
end

