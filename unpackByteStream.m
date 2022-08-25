function output = unpackByteStream(byteStream)
    output = getArrayFromByteStream(byteStream);
    if (strcmp('file', unpackedByteStream.type))
        unpackedBinary = getArrayFromByteStream(output.value);
        fout = fopen(output.name, 'w');
        fwrite(fout, unpackedBinary, 'uint8');
        fclose(fout);
        checksum = Simulink.getFileChecksum(output.name);
        if (strcmp(checksum, output.checksum))
            output = output.name;
        end
%    elseif (strcmp('variable', output.type))
%        output = unpackedByteStream;
    end
end
