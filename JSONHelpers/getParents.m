function parents = getParents(dataDirectory, individual)
    if ~isfield(individual, 'parentIdentifiers')
        return;
    end
    parents = {};
    parentIdentifiers = individual.parentIdentifiers;
    for parentIdentifier = parentIdentifiers
        parents{end+1} = getIndividual(dataDirectory, parentIdentifier);
    end
end

