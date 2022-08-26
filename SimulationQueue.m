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

        function [data, id] = pop(obj)
            % TODO: Find out how does keys() function return values and
            % clean this up
            for queueKeyCell = keys(obj.queue)
                id = queueKeyCell{1};
                data = obj.queue(id);
                remove(obj.queue, id);
                break;
            end
        end
    end
end