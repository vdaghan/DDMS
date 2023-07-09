classdef InputTracker
    properties
        canTrack
        directory
        lastVisualisationChecksum
        
        processedInputFiles
        unprocessedInputFiles
        inprocessInputFiles
    end
    
    methods
        function obj = InputTracker()
            obj.processedInputFiles = [];
            obj.unprocessedInputFiles = [];
            obj.inprocessInputFiles = [];
            obj.lastVisualisationChecksum = nan;
            
            obj.canTrack = false;
            obj.directory = '';
            if isfile('trackedDirectory.json')
                jsontext = fileread('trackedDirectory.json');
                directory = jsondecode(jsontext);
                if exist(directory, 'file')
                    obj.directory = directory;
                    obj.canTrack = true;
                end
            end
        end
        
        function retVal = tracks(obj)
            retVal = obj.canTrack;
        end
        
        function obj = update(obj)
            filesInDirectory = [getFilesInDirectory(obj.directory, '.input'), getFilesInDirectory(obj.directory, '.output')];
            if isempty(filesInDirectory)
                return;
            end
            
            inputFiles = [];
            outputFiles = [];
            for fileIndex = 1:length(filesInDirectory)
                fileName = filesInDirectory{fileIndex};
                %fileName = file.name;
                [simID, type] = parseFilename(fileName);
                if strcmp('input', type)
                    inputFiles(end+1) = simID;
                elseif strcmp('output', type)
                    outputFiles(end+1) = simID;
                end
            end
            inputFiles = sort(inputFiles);
            outputFiles = sort(outputFiles);
            
            processedFiles = intersect(inputFiles, outputFiles);
            processedFilesToNote = setdiff(processedFiles, obj.processedInputFiles);
            obj.processedInputFiles = union(obj.processedInputFiles, processedFilesToNote);
            
            obj.inprocessInputFiles = setdiff(obj.inprocessInputFiles, obj.processedInputFiles);
            
            obj.unprocessedInputFiles = setdiff(setdiff(inputFiles, outputFiles), obj.inprocessInputFiles);

            visualisationFileName = obj.directory + "/../visualisation/visualise.json";
            visualisationFile = dir(visualisationFileName);
            if ~isempty(visualisationFile)
                checksum = obj.lastVisualisationChecksum;
                try
                    checksum = string(Simulink.getFileChecksum(visualisationFileName));
                catch

                end
                if (~strcmp(checksum, obj.lastVisualisationChecksum))
                    obj.lastVisualisationChecksum = checksum;
                    simulateFromJSON(visualisationFileName);
                end
            end
        end
        
        function obj = reserveFileToProcess(obj, simID)
            obj.unprocessedInputFiles = setdiff(obj.unprocessedInputFiles, simID);
%             obj.inprocessInputFiles = union(obj.inprocessInputFiles, setID);
            obj.inprocessInputFiles = union(obj.inprocessInputFiles, simID);
        end
        
        function obj = releaseFileFromProcess(obj, simID)
            obj.inprocessInputFiles = setdiff(obj.inprocessInputFiles, simID);
            obj.unprocessedInputFiles = union(obj.unprocessedInputFiles, simID);
        end
        
        function [obj, reservedFiles] = reserveFilesToProcess(obj, numFiles)
            if -1 == numFiles
                reservedFiles = obj.unprocessedInputFiles;
            else
                reservedFiles = obj.unprocessedInputFiles(1:numFiles);
            end
            obj.unprocessedInputFiles = setdiff(obj.unprocessedInputFiles, reservedFiles);
            obj.inprocessInputFiles = union(obj.inprocessInputFiles, reservedFiles);
        end
        function jsonObject = decodeSimulationInput(obj, simID)
            jsonObject = jsonFileToStruct(obj.directory + "/" + num2str(simID) + ".input");
        end
        function obj = encodeSimulationOutput(obj, simID, simulationOutput)
            ignoredFields = {'tout', 'xout'};
            fields = who(simulationOutput);
            fields = setdiff(fields, ignoredFields);
            jsonObject = struct();
            for i = 1:length(fields)
                field = fields{i};
                r = regexp(field, '_', 'split');
                if 1 == length(r)
                    jsonObject.outputs.(field) = simulationOutput.(field);
                else
                    structName = r{1};
                    varName = r{2};
                    jsonObject.(structName).(varName) = simulationOutput.(field);
                end
            end
            stopEvent = simulationOutput.SimulationMetadata.ExecutionInfo.StopEvent;
            if (strcmp(stopEvent, 'DiagnosticError') || strcmp(stopEvent, 'Timeout'))
                %jsonObject.error = simulationOutput.ErrorMessage;
                jsonObject.error = simulationOutput.SimulationMetadata.ExecutionInfo.StopEventDescription;
            end
            jsonObject.metadata.simulationSteps = length(simulationOutput.tout);
            jsonObject.metadata.totalTime = simulationOutput.SimulationMetadata.TimingInfo.TotalElapsedWallTime;
            encodedJson = jsonencode(jsonObject);
            fid = fopen(obj.directory + "/" + string(simID) + ".output", 'w');
            fprintf(fid, "%s", encodedJson);
            fclose(fid);
        end
    end
end

