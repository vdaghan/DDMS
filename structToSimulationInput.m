function simulationInput = structToSimulationInput(str)
    simulationInput = Simulink.SimulationInput("handstand");
    simulationInput = simulationInput.setVariable('simulationId', 0); % This is stupid...
    fnames = fieldnames(str);
    for findex = 1:length(fnames)
        fieldName = fnames{findex};
        simulationInput = simulationInput.setVariable(fieldName, str.(fieldName)); % This is stupid...
    end
end