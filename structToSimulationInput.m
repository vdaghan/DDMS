function simulationInput = structToSimulationInput(str, model)
%     simulationInput = Simulink.SimulationInput("barHandstand");
%     simulationInput = Simulink.SimulationInput("handstand");
    if isempty(model)
        model = "mizutoriHandstand";
    end
    simulationInput = Simulink.SimulationInput(model);
    simulationInput = simulationInput.setVariable('simulationId', 0); % This is stupid...
    fnames = fieldnames(str);
    for findex = 1:length(fnames)
        fieldName = fnames{findex};
        simulationInput = simulationInput.setVariable(fieldName, str.(fieldName)); % This is stupid...
    end
end