classdef InputTracker
    properties
        canTrack
        directory
        
        processedInputFiles
        unprocessedInputFiles
        inprocessInputFiles
    end
    
    methods
        function obj = InputTracker()
            obj.processedInputFiles = [];
            obj.unprocessedInputFiles = [];
            obj.inprocessInputFiles = [];
            
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
            filesInDirectory = filesInDirectory(endsWith({filesInDirectory.name}, '.json'));
            
            if isempty(filesInDirectory)
                return;
            end
            inputFiles = [];
            outputFiles = [];
            for fileIndex = 1:length(filesInDirectory)
                file = filesInDirectory(fileIndex);
                fileName = file.name;
                [simID, type] = InputTracker.parseFileName(fileName);
                if strcmp('in', type)
                    inputFiles(end+1) = simID;
                elseif strcmp('out', type)
                    outputFiles(end+1) = simID;
                end
            end
            inputFiles = sort(inputFiles);
            outputFiles = sort(outputFiles);
            
            processedFiles = intersect(inputFiles, outputFiles);
            processedFilesToNote = setdiff(processedFiles, obj.processedInputFiles);
            obj.processedInputFiles = union(obj.processedInputFiles, processedFilesToNote);
            
            obj.unprocessedInputFiles = setdiff(setdiff(inputFiles, outputFiles), obj.inprocessInputFiles);
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
            jsonText = fileread(obj.directory + "/" + num2str(simID) + "_in.json");
            jsonObject = jsondecode(jsonText);
        end
    end
    methods(Static)
        function jsonObject = decodeFile(fileName)
            jsonText = fileread(fileName);
            jsonObject = jsondecode(jsonText);
        end
        
        function [simID, type] = parseFileName(fileName)
            r1 = regexp(fileName, '_', 'split');
            r2 = regexp(r1{2}, '\.', 'split');
            r1 = r1{1};
            r2 = r2{1};
            simID = sscanf(r1, '%u');
            type = r2;
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

