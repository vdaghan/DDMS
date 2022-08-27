testFolder = "./test";
if (exist(testFolder, 'file'))
    rmdir(testFolder, 's');
end
mkdir(testFolder);
copyfile("handstand.slx", testFolder + "/handstand.slx");

params = struct();
params.simStart = 0.0;
params.simStop = 4.095;
params.simStep = 0.001;
params.simSamples = 4096;
timeVector = (params.simStart:params.simStep:params.simStop)';
for i = 1:6
    torque = struct();
    torque.wrist = rand(params.simSamples, 1);
    torque.shoulder = rand(params.simSamples, 1);
    torque.hip = rand(params.simSamples, 1);
    simulationInput = struct('time', timeVector, 'params', params, 'torque', torque);
    encodedJson = jsonencode(simulationInput);
    fid = fopen(testFolder + "/" + string(i) + "_in.json", 'w');
    fprintf(fid, "%s", encodedJson);
    fclose(fid);
%     inp = Simulink.SimulationInput('handstand');
%     inp = inp.setVariable('simulationInput', simulationInput);
%     inp = inp.setVariable('params', params);
%     save(testFolder + "/" + string(i) + "_in.mat", 'inp');
end

jsontext = jsonencode(testFolder);
fid = fopen("trackedDirectory.json", 'w');
fprintf(fid, "%s", jsontext);
fclose(fid);