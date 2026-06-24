%% =========================================================
% DATA QUALITY ASSESSMENT
% Vibration Dataset
% =========================================================

clear;
clc;
close all;

%% =========================================================
% ROOT FOLDER
% =========================================================

rootFolder = 'Motor';

%% =========================================================
% FIND ALL CSV FILES
% =========================================================

csvFiles = dir(fullfile(rootFolder,'**','*.csv'));

fprintf('\n');
fprintf('========================================\n');
fprintf('DATA QUALITY ASSESSMENT\n');
fprintf('========================================\n');

fprintf('CSV files found: %d\n',length(csvFiles));

%% =========================================================
% INITIALIZATION
% =========================================================

allAx = [];
allAy = [];
allAz = [];

totalMissing = 0;
totalSamples = 0;

%% =========================================================
% LOOP THROUGH FILES
% =========================================================

for k = 1:length(csvFiles)

    filePath = fullfile( ...
        csvFiles(k).folder,...
        csvFiles(k).name);

    fprintf('Reading %d/%d -> %s\n',...
        k,length(csvFiles),csvFiles(k).name);

    T = readtable(filePath);

    ax = T.ax;
    ay = T.ay;
    az = T.az;

    totalMissing = totalMissing + ...
        sum(sum(ismissing(T)));

    totalSamples = totalSamples + height(T);

    allAx = [allAx; ax];
    allAy = [allAy; ay];
    allAz = [allAz; az];

end

%% =========================================================
% DATASET OVERVIEW
% =========================================================

fprintf('\n');
fprintf('========================================\n');
fprintf('DATASET OVERVIEW\n');
fprintf('========================================\n');

fprintf('Total samples: %d\n',totalSamples);

fprintf('Missing values: %d\n',totalMissing);

fprintf('Missing percentage: %.8f %%\n',...
    100*totalMissing/totalSamples);

%% =========================================================
% DESCRIPTIVE STATISTICS
% =========================================================

fprintf('\n');
fprintf('========================================\n');
fprintf('DESCRIPTIVE STATISTICS\n');
fprintf('========================================\n');

axesNames = {'X','Y','Z'};
axesData = {allAx,allAy,allAz};

for i = 1:3

    data = axesData{i};

    fprintf('\nAxis %s\n',axesNames{i});
    fprintf('------------------------\n');

    fprintf('Mean      : %.6f\n',mean(data));
    fprintf('Median    : %.6f\n',median(data));
    fprintf('Std       : %.6f\n',std(data));
    fprintf('Variance  : %.6f\n',var(data));

    fprintf('Minimum   : %.6f\n',min(data));
    fprintf('Maximum   : %.6f\n',max(data));

    fprintf('Skewness  : %.6f\n',skewness(data));
    fprintf('Kurtosis  : %.6f\n',kurtosis(data));

end

%% =========================================================
% NORMALITY TEST
% =========================================================

fprintf('\n');
fprintf('========================================\n');
fprintf('KOLMOGOROV-SMIRNOV TEST\n');
fprintf('========================================\n');

sampleSize = min(5000,length(allAx));

idx = randperm(length(allAx),sampleSize);

[hx,px] = kstest(allAx(idx));
[hy,py] = kstest(allAy(idx));
[hz,pz] = kstest(allAz(idx));

fprintf('\nAxis X -> h=%d | p=%.8f\n',hx,px);
fprintf('Axis Y -> h=%d | p=%.8f\n',hy,py);
fprintf('Axis Z -> h=%d | p=%.8f\n',hz,pz);

%% =========================================================
% OUTLIER ANALYSIS
% =========================================================

fprintf('\n');
fprintf('========================================\n');
fprintf('OUTLIER ANALYSIS\n');
fprintf('========================================\n');

outX = isoutlier(allAx);
outY = isoutlier(allAy);
outZ = isoutlier(allAz);

fprintf('X Outliers: %d (%.3f%%)\n',...
    sum(outX),...
    100*sum(outX)/length(allAx));

fprintf('Y Outliers: %d (%.3f%%)\n',...
    sum(outY),...
    100*sum(outY)/length(allAy));

fprintf('Z Outliers: %d (%.3f%%)\n',...
    sum(outZ),...
    100*sum(outZ)/length(allAz));

%% =========================================================
% CORRELATION MATRIX
% =========================================================

corrMatrix = corrcoef([allAx allAy allAz]);

disp('Correlation Matrix');
disp(corrMatrix);

%% =========================================================
% HISTOGRAMS
% =========================================================

figure;
histogram(allAx,100);
title('Histogram - Axis X');
xlabel('Acceleration');
ylabel('Count');
grid on;

figure;
histogram(allAy,100);
title('Histogram - Axis Y');
xlabel('Acceleration');
ylabel('Count');
grid on;

figure;
histogram(allAz,100);
title('Histogram - Axis Z');
xlabel('Acceleration');
ylabel('Count');
grid on;

%% =========================================================
% BOXPLOT
% =========================================================

figure;

boxplot([allAx allAy allAz],...
    'Labels',{'X','Y','Z'});

title('Global Boxplot');
ylabel('Acceleration');
grid on;

%% =========================================================
% CORRELATION HEATMAP
% =========================================================

figure;

heatmap( ...
    {'X','Y','Z'},...
    {'X','Y','Z'},...
    corrMatrix);

title('Correlation Matrix');

%% =========================================================
% AUTOCORRELATION
% =========================================================

N = min(5000,length(allAx));

figure;
autocorr(allAx(1:N));
title('Autocorrelation - X');

figure;
autocorr(allAy(1:N));
title('Autocorrelation - Y');

figure;
autocorr(allAz(1:N));
title('Autocorrelation - Z');

%% =========================================================
% EXPORT SUMMARY
% =========================================================

Summary = table(...
    [mean(allAx);mean(allAy);mean(allAz)],...
    [std(allAx);std(allAy);std(allAz)],...
    [var(allAx);var(allAy);var(allAz)],...
    [skewness(allAx);skewness(allAy);skewness(allAz)],...
    [kurtosis(allAx);kurtosis(allAy);kurtosis(allAz)],...
    'VariableNames',...
    {'Mean','Std','Variance','Skewness','Kurtosis'},...
    'RowNames',...
    {'X','Y','Z'});

writetable(...
    Summary,...
    'DataQualitySummary.csv',...
    'WriteRowNames',true);

fprintf('\nSummary saved to DataQualitySummary.csv\n');
fprintf('Finished.\n');