function properties = collectProperties()
    properties = struct();
    properties.id = java.net.InetAddress.getLocalHost.toString;
    properties.benchmarkResult = getBenchmarkResult();
    properties.numCores = maxNumCompThreads;
    properties.MATLABVersion = version;
    properties.affinity = -1;
end