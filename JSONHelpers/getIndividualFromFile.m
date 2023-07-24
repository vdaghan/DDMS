function individual = getIndividualFromFile(filename)
    jsonText = fileread(filename);
    individual = jsondecode(jsonText);
end
