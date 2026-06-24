clear;
clc;
close all;

%% CONFIGURAÇÕES

Fs = 100;
windowSize = 200; % 2 segundos

rootFolder = './Motores';

folders = {
    'M1_1260',1;
    'M1_1320',2;
    'M1_1500',3;
    'M2_1735_Saudavel',4;
};

%% VARIÁVEIS GLOBAIS

allX = [];
allY = [];
allZ = [];

FeatureTable = table();

missingValues = 0;
totalFiles = 0;

%% PROCESSAMENTO

for k = 1:size(folders,1)

    folderName = folders{k,1};
    classLabel = folders{k,2};

    files = dir(fullfile(rootFolder,folderName,'*.csv'));

    fprintf('Lendo pasta: %s\n',folderName);

    for n = 1:length(files)

        totalFiles = totalFiles + 1;

        fileName = fullfile(files(n).folder,files(n).name);

        T = readtable(fileName);

        missingValues = missingValues + ...
            sum(sum(ismissing(T)));

        t = T.t;
        ax = T.ax;
        ay = T.ay;
        az = T.az;

        allX = [allX; ax];
        allY = [allY; ay];
        allZ = [allZ; az];

        %% JANELAMENTO

        N = length(ax);

        numWindows = floor(N/windowSize);

        for w = 1:numWindows

            idxStart = (w-1)*windowSize + 1;
            idxEnd   = w*windowSize;

            xw = ax(idxStart:idxEnd);
            yw = ay(idxStart:idxEnd);
            zw = az(idxStart:idxEnd);

            %% FEATURES TEMPO

            RMS_X = rms(xw);
            RMS_Y = rms(yw);
            RMS_Z = rms(zw);

            Mean_X = mean(xw);
            Mean_Y = mean(yw);
            Mean_Z = mean(zw);

            STD_X = std(xw);
            STD_Y = std(yw);
            STD_Z = std(zw);

            VAR_X = var(xw);
            VAR_Y = var(yw);
            VAR_Z = var(zw);

            Kurt_X = kurtosis(xw);
            Kurt_Y = kurtosis(yw);
            Kurt_Z = kurtosis(zw);

            Skew_X = skewness(xw);
            Skew_Y = skewness(yw);
            Skew_Z = skewness(zw);

            Peak_X = max(abs(xw));
            Peak_Y = max(abs(yw));
            Peak_Z = max(abs(zw));

            P2P_X = max(xw)-min(xw);
            P2P_Y = max(yw)-min(yw);
            P2P_Z = max(zw)-min(zw);

            %% FFT

            fftX = abs(fft(xw));
            fftY = abs(fft(yw));
            fftZ = abs(fft(zw));

            L = length(xw);

            f = Fs*(0:L-1)/L;

            [~,ix] = max(fftX(1:floor(L/2)));
            [~,iy] = max(fftY(1:floor(L/2)));
            [~,iz] = max(fftZ(1:floor(L/2)));

            DomFreq_X = f(ix);
            DomFreq_Y = f(iy);
            DomFreq_Z = f(iz);

            Energy_X = sum(fftX.^2);
            Energy_Y = sum(fftY.^2);
            Energy_Z = sum(fftZ.^2);

            %% TABELA

            row = table( ...
                classLabel,...
                RMS_X,RMS_Y,RMS_Z,...
                Mean_X,Mean_Y,Mean_Z,...
                STD_X,STD_Y,STD_Z,...
                VAR_X,VAR_Y,VAR_Z,...
                Kurt_X,Kurt_Y,Kurt_Z,...
                Skew_X,Skew_Y,Skew_Z,...
                Peak_X,Peak_Y,Peak_Z,...
                P2P_X,P2P_Y,P2P_Z,...
                DomFreq_X,DomFreq_Y,DomFreq_Z,...
                Energy_X,Energy_Y,Energy_Z);

            FeatureTable = [FeatureTable; row];

        end

    end
end
%% Histograma
figure('Name','Global Histograms','NumberTitle','off');

subplot(3,1,1)
histogram(allX,50)
grid on
title('Axis X')
xlabel('Acceleration')
ylabel('Count')

subplot(3,1,2)
histogram(allY,50)
grid on
title('Axis Y')
xlabel('Acceleration')
ylabel('Count')

subplot(3,1,3)
histogram(allZ,50)
grid on
title('Axis Z')
xlabel('Acceleration')
ylabel('Count')

sgtitle('Global Distribution of Acceleration Signals')

%% Boxplot
figure

boxplot([allX allY allZ], ...
{'X','Y','Z'})

title('Global Distribution of Acceleration Signals')
ylabel('Acceleration')

%% Matriz Correlação
corrMatrix = corrcoef([allX allY allZ]);

figure

heatmap({'X','Y','Z'},...
        {'X','Y','Z'},...
        corrMatrix)

title('Correlation Matrix')

%% Boxplot RMS por Class
figure('Name','RMS Distribution','NumberTitle','off');

boxplot(FeatureTable.RMS_X,...
         FeatureTable.classLabel)

title('RMS Distribution by Class')
xlabel('Class')
ylabel('RMS')

xticklabels({'1260','1320','1500','Healthy'})
grid on

%% Boxplot Kurtosis
figure('Name','Kurtosis Distribution',...
       'NumberTitle','off');

boxplot(FeatureTable.Kurt_X,...
         FeatureTable.classLabel)

title('Kurtosis Distribution by Class')
xlabel('Class')
ylabel('Kurtosis')

xticklabels({'1260','1320','1500','Healthy'})
grid on

%% Correlação das Features

SelectedFeatures = [ ...
FeatureTable.RMS_X ...
FeatureTable.STD_X ...
FeatureTable.Kurt_X ...
FeatureTable.Skew_X ...
FeatureTable.Peak_X ...
FeatureTable.P2P_X ...
FeatureTable.Energy_X ];

featureNames = { ...
'RMS',...
'STD',...
'Kurtosis',...
'Skewness',...
'Peak',...
'Peak2Peak',...
'Energy'};

corrMatrix = corrcoef(SelectedFeatures);

figure('Name','Feature Correlation',...
       'NumberTitle','off');

heatmap(featureNames,...
        featureNames,...
        corrMatrix);

title('Feature Correlation Matrix')

%% =====================================================
% FEATURE SPACE
% RMS x KURTOSIS
% =====================================================

figure('Name','Feature Space RMS x Kurtosis',...
       'NumberTitle','off');

gscatter(FeatureTable.RMS,...
         FeatureTable.Kurtosis,...
         FeatureTable.Class,...
         'brgm',...
         'o^sd',...
         8);

grid on

xlabel('RMS')
ylabel('Kurtosis')

title('Feature Space: RMS vs Kurtosis')

legend('Location','best')