function localAddress = getLocalAddress()
    [~,hostname] = system('hostname');
    hostname = string(strtrim(hostname));
    localAddress = resolvehost(hostname,"address");
end