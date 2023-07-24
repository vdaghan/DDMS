function [fig1, fig2] = plotIndividualTorques(individual, fig1, fig2)
    numTorques = length(fields(individual.genotype.torque));
    numAngles = length(fields(individual.phenotype.angles));
    time = individual.genotype.time;
    maxRows = max([numTorques, numAngles]);

    figure(fig1)
    tiledlayout(maxRows, 2);
    i = 0;
    torqueNames = string(fields(individual.genotype.torque))';
    for torqueName = torqueNames
        nexttile(1 + 2 * i);
        plot(time, individual.genotype.torque.(torqueName));
        title(torqueName + " torku")
        xlabel("Zaman (sn)")
        ylabel("Tork (Nm)")
        i = i + 1;
    end
    i = 0;
    angleNames = string(fields(individual.phenotype.angles))';
    for angleName = angleNames
        nexttile(2 + 2 * i);
        plot(time, individual.phenotype.angles.(angleName)*180/pi);
        title(angleName + " açısı")
        xlabel("Zaman (sn)")
        ylabel("Açı (derece)")
        i = i + 1;
    end

    figure(fig2)
    tiledlayout(maxRows, 1);
    i = 0;
    torqueNames = string(fields(individual.genotype.torque))';
    for torqueName = torqueNames
        nexttile;

        torque = individual.genotype.torque.(torqueName);
        rotatum = diff(torque)./diff(time);
        plot((time(1:end-1)+time(2:end))/2, rotatum);
        title(torqueName + " rotatum")
        xlabel("Zaman (sn)")
        ylabel("Rotatum (Nm/s)")
        i = i + 1;
    end
end