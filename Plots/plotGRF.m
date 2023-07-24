runPath = uigetdir;
dataDir = runPath + "\data";
generations = getGenerations(dataDir);
lastGen = generations(end);
bestIndividual = findBestIndividual(dataDir, lastGen, "fitness", 'descend');
bestIndividualGeneration = bestIndividual.identifier.generation;
bestIndividualIdentifier = bestIndividual.identifier.identifier;
bestIndividualFilename = dataDir + "/" + string(bestIndividualGeneration) + "/" + bestIndividualIdentifier + ".deva";
out = simulateIndividualFromFile(bestIndividualFilename, "handstand");


times = 0:0.01:2.55;

figure;
tiledlayout(4,1);
nexttile;
plot(times, out.fingertipNormalForce)
xlabel("Zaman (s)")
ylabel("Kuvvet (N)")
axis tight
title("el parmak ucu")
nexttile;
plot(times, out.palmNormalForce)
xlabel("Zaman (s)")
ylabel("Kuvvet (N)")
axis tight
title("carpal")
nexttile;
plot(times, out.toeNormalForce)
xlabel("Zaman (s)")
ylabel("Kuvvet (N)")
axis tight
title("ayak parmak ucu")
nexttile;
plot(times, out.heelNormalForce)
xlabel("Zaman (s)")
ylabel("Kuvvet (N)")
axis tight
title("topuk")

figure;
totalGRF = out.fingertipNormalForce + out.palmNormalForce + out.toeNormalForce;
plot(times, totalGRF, "k")
xlabel("Zaman (s)")
ylabel("Kuvvet (N)")
axis tight

cop = out.fingertipNormalForce .* out.fingertipX + out.palmNormalForce .* out.palmX + out.toeNormalForce .* out.toeX;
cop = cop ./ (out.fingertipNormalForce + out.palmNormalForce + out.toeNormalForce);
fingertipContactNan = out.fingertipContact;
fingertipContactNan(fingertipContactNan == 0) = NaN;
palmContactNan = out.palmContact;
palmContactNan(palmContactNan == 0) = NaN;
toeContactNan = out.toeContact;
toeContactNan(toeContactNan == 0) = NaN;
figure;
hold on;
plot(times, out.fingertipX .* fingertipContactNan, "k-")
plot(times, cop, "k--")
plot(times, out.centerOfMassX, "k-.")
plot(times, out.palmX .* palmContactNan, "k-")
plot(times, out.toeX .* toeContactNan, "k-")
axis tight
hold off;
xlabel("Zaman (s)")
ylabel("Konum (m)")
legend(["fingertipX", "cop", "com", "palmX", "toeX"])

figure;
hold on;
plot(times, cop, 'k--')
plot(times, out.centerOfMassX, 'k-')
axis tight
hold off;
xlabel("Zaman (s)")
ylabel("Konum (m)")
legend(["Basınç Merkezi", "Kütle Merkezi"])

edges = 0:0.01:2.55;
thist = histcounts(out.tout, edges);
figure;
tiledlayout(3,1);
nexttile;
plot(out.tout, 'k')
xlabel("Çözüm Adımı")
ylabel("Zaman (s)")
axis tight
nexttile;
plot(edges(1:end-1), thist, 'k')
xlabel("Adım Sayısı")
ylabel("Zaman (s)")
axis tight
nexttile;
handContacts = out.fingertipContact .* out.palmContact;
plot(times, handContacts);
% plot(edges(1:end-1), totalGRF(1:end-1)', 'k-')
xlabel("Zaman (s)")
ylabel("Temas (Var = 1, Yok = 0)")
axis tight
% nexttile;
% anyContactNan = (out.fingertipContact == 0) || (out.palmContact == 0) || (out.toeContact == 0);
% anyContactNan(anyContactNan == 0) = NaN;
% plot(edges(1:end-1), totalGRF(1:end-1)'./thist, 'k-')
axis tight

figure;
tiledlayout(4,1);
nexttile;
plot(out.fingertipContact);
axis tight
nexttile;
plot(out.palmContact);
axis tight
nexttile;
plot(out.toeContact);
axis tight
nexttile;
handContacts = out.fingertipContact .* out.palmContact;
plot(handContacts);
axis tight

