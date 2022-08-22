works = containers.Map("KeyType", 'uint32', "ValueType", 'any');

for i = 1:10
    work = containers.Map();
    work('id') = i;
    params = struct();
    params.simStart = 0.0;
    params.simStop = 4.095;
    params.simStep = 0.001;
    params.simSamples = 4096;
    work('params') = params;
    simulationInput = struct();
    simulationInput.torque.wrist = timeseries(zeros(params.simSamples, 1), (params.simStart:params.simStep:params.simStop)');
    simulationInput.torque.shoulder = timeseries(zeros(params.simSamples, 1), (params.simStart:params.simStep:params.simStop)');
    simulationInput.torque.hip = timeseries(zeros(params.simSamples, 1), (params.simStart:params.simStep:params.simStop)');
    work('simulationInput') = simulationInput;
    works(i) = work;
end
