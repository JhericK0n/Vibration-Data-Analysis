%% =====================================================
% FFT MÉDIA POR CONDIÇÃO
% ======================================================

Fs = 100;

foldersFFT = {
    'M1_1260','1260 RPM';
    'M1_1320','1320 RPM';
    'M1_1500','1500 RPM';
    'M2_1735_Saudavel','Healthy';
};

figure('Name','Average FFT by Condition',...
       'NumberTitle','off');

hold on

for k = 1:size(foldersFFT,1)

    folderName = foldersFFT{k,1};
    labelName  = foldersFFT{k,2};

    files = dir(fullfile(rootFolder,...
                         folderName,...
                         '*.csv'));

    FFTsum = [];
    numFiles = 0;

    for n = 1:length(files)

        fileName = fullfile(files(n).folder,...
                            files(n).name);

        T = readtable(fileName);

        signal = T.az;

        signal = signal - mean(signal);

        N = length(signal);

        Y = fft(signal);

        P2 = abs(Y/N);

        P1 = P2(1:floor(N/2)+1);

        P1(2:end-1) = 2*P1(2:end-1);

        if isempty(FFTsum)

            FFTsum = zeros(size(P1));

        end

        FFTsum = FFTsum + P1;

        numFiles = numFiles + 1;

    end

    FFTmean = FFTsum/numFiles;

    f = Fs*(0:(N/2))/N;

    plot(f,...
         FFTmean,...
         'LineWidth',2,...
         'DisplayName',labelName)

end

grid on
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Average FFT Spectrum by Operating Condition')

legend('Location','best')

xlim([0 50])