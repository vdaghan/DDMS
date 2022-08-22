if (~isfile('benchmarkResult.json'))
    benchValue = bench();
    close all;
    benchmark = struct();
    benchmark.LU = benchValue(1);
    benchmark.FFT = benchValue(2);
    benchmark.ODE = benchValue(3);
    benchmark.Sparse = benchValue(4);
    benchmark.D2 = benchValue(5);
    benchmark.D3 = benchValue(6);
    jsontext = jsonencode(benchmark, PrettyPrint=true);

    fileID = fopen("benchmarkResult.json", 'w');
    fprintf(fileID, jsontext);
    fclose(fileID);
    clear benchValue jsontext fileID;
else
    jsontext = fileread('benchmarkResult.json');
    benchmark = jsondecode(jsontext);
    clear jsontext;
end
