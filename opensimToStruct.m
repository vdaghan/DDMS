% fileID = fopen('osimout.mot','r');
% 
% fclose(fileID);
lines = readlines('inverse_dynamics.sto');
ehLine = 1;
for i = 1:length(lines)
    ehLine = i;
    if contains(lines(i), 'endheader')
        break;
    end
end
tags = lines(ehLine+1);
tags = textscan(tags, '%s', 'Delimiter', '\t','TreatAsEmpty','~');
tagsCells = tags{1,1};
tags = string(tagsCells);
valueLines = lines(ehLine+2:end);
values = [];
for i = 1:length(valueLines)
    line = valueLines(i);
    lineValues = textscan(line, '%f', 'Delimiter', '\t','TreatAsEmpty','~');
    lineValues = lineValues{1,1};
    values = [values; lineValues'];
end
t = array2table(values, 'VariableNames', tagsCells);