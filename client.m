clc;
clear;

mkdir("projects");

%create a tcp/ip client and try to connect to server

generateRandomTimeseries;
load_system('handstand.slx');
simulationInputs = [];
clear simulationInputs;
workIds = keys(works);
for workIndex = 1:length(workIds)
    workId = workIds{workIndex};
    work = works(workId);
    simulationInput = Simulink.SimulationInput('handstand');
    simulationInput = simulationInput.setVariable('simulationInput', work('simulationInput'));
    simulationInput = simulationInput.setVariable('params', work('params'));
    simulationInputs(workIndex) = simulationInput;
end
simulationOutputs = parsim(simulationInputs);
