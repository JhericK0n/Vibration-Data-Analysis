%% =====================================================
% LOAD_01_A11_DATA.M
% Exploratory Analysis of Motor Vibration Dataset
% =====================================================

clear
clc
close all

%% =====================================================
% ROOT FOLDER
% =====================================================

rootFolder = 'motores';

folders = {
    'M1_1260'
    'M1_1320'
    'M1_1500'
    'M2_1735_Saudavel'
};

classNames = {
    '1260RPM'
    '1320RPM'
    '1500RPM'
    'Healthy'
};

%% =====================================================
% FEATURE STORAGE
% =====================================================

RMS_all = [];
STD_all = [];
Kurtosis_all = [];
Skewness_all = [];
Peak_all = [];
Peak2Peak_all = [];
Energy_all = [];
Class_all = {};

%% =====================================================
% PROCESS ALL FILES
% =====================================================

for k = 1:length(folders)

    currentFolder = fullfile(rootFolder,folders{k});

    files = dir(fullfile(currentFolder,'*.csv'));

    fprintf('\nProcessing %s\n',folders{k})

    for n = 1:length(files)

        filename = fullfile(files(n).folder,...
                            files(n).name);

        T = readtable(filename);

        ax = T.ax;
        ay = T.ay;
        az = T.az;

        %% Resultant vibration

        vib = sqrt(ax.^2 + ay.^2 + az.^2);

        %% Features

        RMS_all(end+1,1)       = rms(vib);
        STD_all(end+1,1)       = std(vib);
        Kurtosis_all(end+1,1)  = kurtosis(vib);
        Skewness_all(end+1,1)  = skewness(vib);
        Peak_all(end+1,1)      = max(abs(vib));
        Peak2Peak_all(end+1,1) = peak2peak(vib);
        Energy_all(end+1,1)    = sum(vib.^2);

        Class_all{end+1,1} = classNames{k};

    end
end

%% =====================================================
% FEATURE TABLE
% =====================================================

FeatureTable = table(...
    RMS_all,...
    STD_all,...
    Kurtosis_all,...
    Skewness_all,...
    Peak_all,...
    Peak2Peak_all,...
    Energy_all,...
    categorical(Class_all),...
    'VariableNames',...
    {'RMS',...
     'STD',...
     'Kurtosis',...
     'Skewness',...
     'Peak',...
     'Peak2Peak',...
     'Energy',...
     'Class'});

disp(FeatureTable(1:10,:))

%% =====================================================
% HISTOGRAMS
% =====================================================

figure

subplot(2,4,1)
histogram(RMS_all)
title('RMS')

subplot(2,4,2)
histogram(STD_all)
title('STD')

subplot(2,4,3)
histogram(Kurtosis_all)
title('Kurtosis')

subplot(2,4,4)
histogram(Skewness_all)
title('Skewness')

subplot(2,4,5)
histogram(Peak_all)
title('Peak')

subplot(2,4,6)
histogram(Peak2Peak_all)
title('Peak2Peak')

subplot(2,4,7)
histogram(Energy_all)
title('Energy')

sgtitle('Feature Histograms')

%% =====================================================
% BOXPLOT RMS
% =====================================================

figure

boxplot(FeatureTable.RMS,...
        FeatureTable.Class)

title('RMS Distribution')
ylabel('RMS')

%% =====================================================
% BOXPLOT KURTOSIS
% =====================================================

figure

boxplot(FeatureTable.Kurtosis,...
        FeatureTable.Class)

title('Kurtosis Distribution')
ylabel('Kurtosis')

%% =====================================================
% FEATURE SPACE
% RMS x KURTOSIS
% =====================================================

figure

gscatter(...
    FeatureTable.RMS,...
    FeatureTable.Kurtosis,...
    FeatureTable.Class,...
    'brgm',...
    'o^sd',...
    8)

grid on

xlabel('RMS')
ylabel('Kurtosis')

title('Feature Space: RMS vs Kurtosis')

legend('Location','best')

%% =====================================================
% FEATURE CORRELATION MATRIX
% =====================================================

FeatureNumeric = FeatureTable(:,...
    {'RMS',...
     'STD',...
     'Kurtosis',...
     'Skewness',...
     'Peak',...
     'Peak2Peak',...
     'Energy'});

R = corr(table2array(FeatureNumeric));

figure

imagesc(R)

colormap(parula)
colorbar

axis equal
axis tight

featureNames = FeatureNumeric.Properties.VariableNames;

xticks(1:length(featureNames))
yticks(1:length(featureNames))

xticklabels(featureNames)
yticklabels(featureNames)

title('Feature Correlation Matrix')

for i = 1:size(R,1)

    for j = 1:size(R,2)

        text(j,i,...
            sprintf('%.4f',R(i,j)),...
            'HorizontalAlignment','center')

    end
end

%% =====================================================
% SAVE FEATURE DATASET
% =====================================================

writetable(FeatureTable,...
           'Motor_Features.csv');

disp('Feature dataset saved.')