x = 0:0.1:pi;
t1 = sin(2*x);
t2 = cos(2*x);

% Crossover
weight = 0.3;
co_1 = t1 * weight + t2 * (1 - weight);
co_2 = t2 * weight + t1 * (1 - weight);
plot2_2(x, t1, t2, co_1, co_2);
sgtitle("Çapraz Geçiş");
axis tight
clear weight co_1 co_2;

% Cut and Crossfill
index = 16;
cc_1 = [t1(1:index-1), t2(index:end)];
cc_2 = [t2(1:index-1), t1(index:end)];
plot2_2(x, t1, t2, cc_1, cc_2);
sgtitle("Kes ve Doldur");
clear index cc_1 cc_2;

% Deletion
index = 16;
d = [t2(1:index-1), t2(index+1:end), 0];
plot1_1(x, t2, d);
sgtitle("Silme");
clear index d;

% Insertion
index = 16;
r = 0.42;
i = [t1(1:index-1), r, t1(index:end-1)];
plot1_1(x, t1, i);
sgtitle("Yerleştirme");
clear index i r;

% k-point Crossover
J = [5, 16, 20];
k1 = [t1(1:J(1)-1), t2(J(1):J(2)-1), t1(J(2):J(3)-1), t2(J(3):end)];
k2 = [t2(1:J(1)-1), t1(J(1):J(2)-1), t2(J(2):J(3)-1), t1(J(3):end)];
plot2_2(x, t1, t2, k1, k2);
sgtitle("k-nokta Çapraz Geçiş");
clear J k1 k2;

% TNV
index = 16;
r = 0.42;
t = [t1(1:index-1), r, t1(index+1:end)];
plot1_1(x, t1, t);
sgtitle("TNV (Tek Nükleotid Varyasyon)");
clear index i t;

% Uniform Crossover
rng('default') % For reproducibility
w = rand(length(x),1)';
tp1 = t1 .* w + t2 .* (1 - w);
tp2 = t2 .* w + t1 .* (1 - w);
plot2_2(x, t1, t2, tp1, tp2);
sgtitle("Düzenli Çapraz Geçiş");
clear w tp1 tp2;

% Interpolated Deletion
points1 = [[1,2]; [8,16]; [16,-5]; [24,-16]; [32,4]];
points2 = [[1,2]; [8,16]; [24,-16]; [32,4]];
px = (1:32)';
plot1_1(x, clampedSpline(points1, px), clampedSpline(points2, px));
sgtitle("Ara değerlendirmeli Silme");
clear points1 points2 px;

% Interpolated SNV
points1 = [[1,2]; [8,16]; [16,-5]; [24,-16]; [32,4]];
points2 = [[1,2]; [8,16]; [16,8]; [24,-16]; [32,4]];
px = (1:32)';
plot1_1(x, clampedSpline(points1, px), clampedSpline(points2, px));
sgtitle("Ara değerlendirmeli TNV");
clear points1 points2 px;

function f = plot2_2(x, t1, t2, tp1, tp2)
    f = figure;
    tiledlayout(2,2);
    nexttile(1); plot(x, t1);  xlabel("Zaman (s)"); ylabel("Tork (Nm)"); title("$t_1$",'interpreter','latex');
    nexttile(2); plot(x, t2);  xlabel("Zaman (s)"); ylabel("Tork (Nm)"); title("$t_2$",'interpreter','latex');
    nexttile(3); plot(x, tp1); xlabel("Zaman (s)"); ylabel("Tork (Nm)"); title("$t_1'$",'interpreter','latex');
    nexttile(4); plot(x, tp2); xlabel("Zaman (s)"); ylabel("Tork (Nm)"); title("$t_2'$",'interpreter','latex');
end

function f = plot1_1(x, t, tp)
    f = figure;
    f.PaperType = 'a4';
    f.PaperOrientation = 'landscape';
    tiledlayout(2,1);
    nexttile(1); plot(x, t);  xlabel("Zaman (s)"); ylabel("Tork (Nm)"); title("$t$",'interpreter','latex');
    nexttile(2); plot(x, tp);  xlabel("Zaman (s)"); ylabel("Tork (Nm)"); title("$t'$",'interpreter','latex');
end
