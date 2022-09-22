clc, clear;

input.params.simStart = 0;
input.params.simStep = 0.01;
input.params.simSamples = 512;
input.params.simStop = input.params.simStart + input.params.simStep * (input.params.simSamples - 1);
input.time = (input.params.simStart:input.params.simStep:input.params.simStop)';
input.torque.wrist = zeros(input.params.simSamples, 1);
input.torque.shoulder = zeros(input.params.simSamples, 1);
input.torque.hip = zeros(input.params.simSamples, 1);
input.torque.ankle = zeros(input.params.simSamples, 1);
%input.alignment = [0, 0; eps, -1];
input.alignment = [0, 0; eps, 0];
output = simulateFromStruct(input);
if ~isempty(output.ErrorMessage)
    display(output.ErrorMessage)
else
    display("Simulation took " + num2str(output.SimulationMetadata.TimingInfo.TotalElapsedWallTime) + "s")
    display("Use input.alignment: " + jsonencode(input.alignment))
end
