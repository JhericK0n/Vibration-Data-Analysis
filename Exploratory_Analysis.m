% Limpar ambiente
clear; clc; close all;

 set(0, 'defaultfigurecolor', 'w')

% Importar dados
%dados  = readtable('motor/M1V2-dados_vibracao.csv');
%dados  = readtable('motor/M1V1-vibration_data.csv');
%dados = readtable('dados_com_tempo.csv');
dados = readtable('csv_divididos/bloco_029.csv');
summary(dados)
head(dados)

% Definir variáveis
t  = dados.t;
ax = dados.ax;
ay = dados.ay;
az = dados.az;

fs = 100; % Hz

%% ===== RPM FIXO =====
rpm_fixo = 1260;
f_rot = rpm_fixo / 60; % 20 Hz

%% ===== PRÉ-PROCESSAMENTO =====
ax = ax - mean(ax);
ay = ay - mean(ay);
az = az - mean(az);

% janela
w = hamming(length(ax));
ax_w = ax .* w;
ay_w = ay .* w;
az_w = az .* w;

N = length(ax);
f = (0:N-1)*(fs/N);
f_plot = f(1:N/2);

%% ===== FFT =====
Yx = fft(ax_w);
Yy = fft(ay_w);
Yz = fft(az_w);

Px = abs(Yx/N);
Py = abs(Yy/N);
Pz = abs(Yz/N);

Px = Px(1:N/2);
Py = Py(1:N/2);
Pz = Pz(1:N/2);

%% ===== FREQUÊNCIA DOMINANTE =====
[~, idx_x] = max(Px);
[~, idx_y] = max(Py);
[~, idx_z] = max(Pz);

freq_x = f_plot(idx_x);
freq_y = f_plot(idx_y);
freq_z = f_plot(idx_z);

fprintf('Freq X: %.2f Hz\n', freq_x);
fprintf('Freq Y: %.2f Hz\n', freq_y);
fprintf('Freq Z: %.2f Hz\n', freq_z);

%% =========================================================
%% 1. SINAIS NO TEMPO
figure;
subplot(3,1,1)
plot(t, ax); title('Time - X'); grid on; xlim([0 2610]);
xlabel('mm/s');
ylabel('Time (s)');

subplot(3,1,2)
plot(t, ay); title('Time - Y'); grid on; xlim([0 2610]);
xlabel('mm/s');
ylabel('Time (s)');

subplot(3,1,3)
plot(t, az); title('Time - Z'); grid on; xlim([0 2610]);
xlabel('mm/s');
ylabel('Time (s)');


% ===== ESTATÍSTICAS =====

rms_x = rms(ax);
max_x = max(ax);
min_x = min(ax);
std_x = std(ax);

rms_y = rms(ay);
max_y = max(ay);
min_y = min(ay);
std_y = std(ay);

rms_z = rms(az);
max_z = max(az);
min_z = min(az);
std_z = std(az);

% ===== TABELA =====
tabela_stats = table( ...
    [rms_x; rms_y; rms_z], ...
    [max_x; max_y; max_z], ...
    [min_x; min_y; min_z], ...
    [std_x; std_y; std_z], ...
    'VariableNames', {'RMS','Maximum','Minimum','StdDev'}, ...
    'RowNames', {'X','Y','Z'});

disp(tabela_stats);


%% =========================================================
%% 2. SINAIS NO TEMPO DETALHADO
figure;
subplot(3,1,1)
plot(t, ax); title('Time - X'); grid on; xlim([1 2.8]);
xlabel('mm/s');
ylabel('Time (s)');

subplot(3,1,2)
plot(t, ay); title('Time - Y'); grid on; xlim([1 2.8]);
xlabel('mm/s');
ylabel('Time (s)');

subplot(3,1,3)
plot(t, az); title('Time - Z'); grid on; xlim([1 2.8]);
xlabel('mm/s');
ylabel('Time (s)');

%% =========================================================
%% 3. HISTOGRAMAS
figure;

subplot(3,1,1)
histogram(ax,50); title('Histogram X');

subplot(3,1,2)
histogram(ay,50); title('Histogram Y');

subplot(3,1,3)
histogram(az,50); title('Histogram Z');

%% =========================================================
%% 4. BOXPLOT
figure;
boxplot([ax ay az], 'Labels', {'X','Y','Z'});
yline(0, '--c', ' 0');
title('Vibration Boxplot'); 

%% =========================================================
%% 5. CORRELAÇÃO
X = [ax ay az];

nomes = {'A_x','A_y','A_z'};
R = corrcoef(X);


figure('color','white')
h = heatmap(nomes, nomes, R);

h.ColorLimits = [-1 1];

title('Correlation Matrix between Vibration Variables')


%% =========================================================
%% 6. FFT - X
figure;
plot(f_plot, Px); hold on; xlim([0 50]);
xline(f_rot/3, '--c', '1/3x');
xline(f_rot/2, '--m', '1/2x');
xline(f_rot, '--r', '1x');
xline(2*f_rot, '--g', '2x');
xline(3*f_rot, '--k', '3x');
title('FFT - X');
xlabel('Frequency (Hz)');
ylabel('mm/s');
grid on;

%% =========================================================
%% 7. FFT - Y
figure;
plot(f_plot, Py); hold on; xlim([0 50]);
xline(f_rot/3, '--c', '1/3x');
xline(f_rot/2, '--m', '1/2x');
xline(f_rot, '--r', '1x');
xline(2*f_rot, '--g', '2x');
xline(3*f_rot, '--k', '3x');
title('FFT - Y');
xlabel('Frequency (Hz)');
ylabel('mm/s');
grid on;

%% =========================================================
%% 8. FFT - Z
figure;
plot(f_plot, Pz); hold on; xlim([0 50]);
xline(f_rot/3, '--c', '1/3x');
xline(f_rot/2, '--m', '1/2x');
xline(f_rot, '--r', '1x');
xline(2*f_rot, '--g', '2x');
xline(3*f_rot, '--k', '3x');
title('FFT - Z');
xlabel('Frequency (Hz)');
ylabel('mm/s');
grid on;

%% =========================================================
%% 9. FFT COMPARATIVA (X, Y, Z)
figure;
plot(f_plot, Px, 'r'); hold on;
plot(f_plot, Py, 'g');
plot(f_plot, Pz, 'b');
legend('X','Y','Z');
title('Comparative FFT');
xlabel('Frequency (Hz)');
ylabel('mm/s');
grid on;

