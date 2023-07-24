function [out, simulationInput] = simulateFromStruct(s, model)
    if isempty(model)
        model = "mizutoriHandstand";
    end
    simulationInput = structToSimulationInput(s, model);
    load_system(model);
%     load_system('barHandstand');
    warning('off','sm:sli:setup:compile:SteadyStateStartNotSupported');
    beep off;
    %out = sim(simulationInput, 'UseFastRestart', 'on');
    simulationInput = simulationInput.setModelParameter('SimulationMode', 'normal');
    out = sim(simulationInput);
end

