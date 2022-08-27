classdef SimulationQueue
    properties
        queue
    end

    methods
        function obj = SimulationQueue()
            obj.queue = containers.Map();
        end

        function obj = push(obj, id, data)
            obj.queue(id) = data;
        end

        function [data, id] = pop(obj, varargin)
            % TODO: Find out how does keys() function return values and
            % clean this up
            if 0 == size(varargin)
                num = 1;
            else
                num = varargin{1};
            end
            data = [];
            id = [];
            for i = 1:num
                for queueKeyCell = keys(obj.queue)
                    id(i) = queueKeyCell{1};
                    data(i) = obj.queue(id(i));
                    remove(obj.queue, id(i));
                    break;
                end
            end
        end
    end
end