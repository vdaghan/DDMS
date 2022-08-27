classdef SimulationQueue
    properties
        queue
    end

    methods
        function obj = SimulationQueue()
            obj.queue = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
        end

        function l = length(obj)
            l = length(obj.queue);
        end

        function b = isempty(obj)
            b = isempty(obj.queue);
        end

        function obj = push(obj, id, data)
            obj.queue(id) = data;
        end

        function [data, id] = pop(obj, varargin)
            % TODO: Find out how does keys() function return values and
            % clean this up
            if 0 == size(varargin)
                num = 1;
            elseif -1 == varargin{1}
                num = length(keys(obj.queue));
            else
                num = varargin{1};
            end
            data = {};
            id = [];
            for i = 1:num
                for queueKeyCell = keys(obj.queue)
                    id(i) = queueKeyCell{1};
                    data{i} = obj.queue(uint32(id(i)));
                    remove(obj.queue, id(i));
                    break;
                end
            end
        end
    end
end