function balance = calculateBalance(individual)
    centerOfMassX = individual.phenotype.outputs.("centerOfMassX");
    fingerTipX = individual.phenotype.outputs.("fingertipX");
    palmX = individual.phenotype.outputs.("palmX");
    zeroIndices = (min(fingerTipX, palmX) <= centerOfMassX) & (centerOfMassX <= max(fingerTipX, palmX));
    balance = min(centerOfMassX - fingerTipX, centerOfMassX - palmX);
    balance(zeroIndices) = 0;
end