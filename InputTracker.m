classdef InputTracker
    properties
        canTrack
        directory
        lastVisualisation
        
        processedInputFiles
        unprocessedInputFiles
        inprocessInputFiles
    end
    
    methods
        function obj = InputTracker()
            obj.processedInputFiles = [];
            obj.unprocessedInputFiles = [];
            obj.inprocessInputFiles = [];
            obj.lastVisualisation = tic;
            
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
            filesInDirectory = dir(obj.directory);
            filesInDirectory = filesInDirectory(~[filesInDirectory.isdir]);
            inputFilesInDirectory = filesInDirectory(endsWith({filesInDirectory.name}, '.input'));
            outputFilesInDirectory = filesInDirectory(endsWith({filesInDirectory.name}, '.output'));
            inputFilesInDirectory = struct2table(inputFilesInDirectory);
            outputFilesInDirectory = struct2table(outputFilesInDirectory);
            filesInDirectory = [inputFilesInDirectory; outputFilesInDirectory];
            filesInDirectory = table2struct(filesInDirectory);
            
            if isempty(filesInDirectory)
                return;
            end
            inputFiles = [];
            outputFiles = [];
            for fileIndex = 1:length(filesInDirectory)
                file = filesInDirectory(fileIndex);
                fileName = file.name;
                [simID, type] = InputTracker.parseFileName(fileName);
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

            if toc(obj.lastVisualisation) > 30
                obj.lastVisualisation = tic;
                visualisationFileName = obj.directory + "/../visualisation/visualise.json";
                visualisationFile = dir(visualisationFileName);
                if isempty(visualisationFile)
                    return;
                end
                simulateFromJSON(visualisationFileName);
            end
        end
        
        function obj = reserveFileToProcess(obj, simID)
            obj.unprocessedInputFiles = setdiff(obj.unprocessedInputFiles, simID);
            obj.inprocessInputFiles = union(obj.inprocessInputFiles, setID);
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
                jsonObject.outputs.(field) = simulationOutput.(field);
            end
            stopEvent = simulationOutput.SimulationMetadata.ExecutionInfo.StopEvent;
            if (strcmp(stopEvent, 'DiagnosticError'))
                jsonObject.error = simulationOutput.ErrorMessage;
            end
            jsonObject.metadata.totalTime = simulationOutput.SimulationMetadata.TimingInfo.TotalElapsedWallTime;
            encodedJson = jsonencode(jsonObject);
            fid = fopen(obj.directory + "/" + string(simID) + ".output", 'w');
            fprintf(fid, "%s", encodedJson);
            fclose(fid);
        end
    end
    methods(Static)
        function jsonObject = decodeFile(fileName)
            jsonText = fileread(fileName);
            jsonObject = jsondecode(jsonText);
        end
        
        function [simID, type] = parseFileName(fileName)
            r1 = regexp(fileName, '\.', 'split');
            simID = r1{1};
            type = r1{2};
            simID = sscanf(simID, '%u');
        end

%             function jsonText = encodeSimulationInput(fileName)
%                 matObj = matfile(fileName);
%                 simulationInput = matObj.inp;
%                 sourceObj = struct();
%                 simIn = simulationInput.Variables.simulationInput;
%                 jsonObject = jsonencode(simulationInput);
%             end
    end
end

