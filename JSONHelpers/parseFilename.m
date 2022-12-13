function [id, type] = parseFilename(filename)
    r1 = regexp(filename, '\.', 'split');
    simID = r1{1};
    type = r1{2};
    id = sscanf(simID, '%u');
end

