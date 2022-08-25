function packedStruct = packFile(fileName)
    packedStruct = struct();
    packedStruct.type = 'file';
    packedStruct.name = fileName;
    
    fin = fopen(fileName, 'r');
    inFile = fread(fin, 'uint8');
    fclose(fin);

    packedStruct.checkSum = Simulink.getFileChecksum(fileName);
    packedStruct.value = getByteStreamFromArray(inFile);
end
