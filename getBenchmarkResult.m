function benchmarkResult = getBenchmarkResult()
    if (~isfile('benchmarkResult.json'))
        benchValue = bench();
        close all;
        benchmarkResult = struct();
        benchmarkResult.LU = benchValue(1);
        benchmarkResult.FFT = benchValue(2);
        benchmarkResult.ODE = benchValue(3);
        benchmarkResult.Sparse = benchValue(4);
        benchmarkResult.D2 = benchValue(5);
        benchmarkResult.D3 = benchValue(6);
        jsontext = jsonencode(benchmarkResult, PrettyPrint=true);
    
        fileID = fopen("benchmarkResult.json", 'w');
        fprintf(fileID, jsontext);
        fclose(fileID);
    else
        jsontext = fileread('benchmarkResult.json');
        benchmarkResult = jsondecode(jsontext);
    end
end