%% =====================================================
% FFT MÉDIA POR CONDIÇÃO
% COM HARMÔNICOS
% =====================================================

Fs = 100;

conditions = {
'M1_1260',1260;
'M1_1320',1320;
'M1_1500',1500;
'M2_1735_Saudavel',1735;
};

for k = 1:size(conditions,1)

    folderName = conditions{k,1};
    rpm        = conditions{k,2};

    fr = rpm/60;

    files = dir(fullfile(rootFolder,...
                         folderName,...
                         '*.csv'));

    FFTsum = [];

    countFiles = 0;

    for n = 1:length(files)

        fileName = fullfile(files(n).folder,...
                            files(n).name);

        T = readtable(fileName);

        signal = sqrt( ...
            T.ax.^2 + ...
            T.ay.^2 + ...
            T.az.^2 );

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

        countFiles = countFiles + 1;

    end

    FFTmean = FFTsum/countFiles;

    f = Fs*(0:(N/2))/N;

    figure

    plot(f,...
         FFTmean,...
         'LineWidth',1.5)

    hold on

    xline(fr/3,'--r','1/3x')
    xline(fr/2,'--m','1/2x')
    xline(fr,'--g','1x')
    xline(2*fr,'--b','2x')

    if (3*fr) <= 50
        xline(3*fr,'--k','3x')
    end

    grid on

    xlabel('Frequency (Hz)')
    ylabel('Amplitude')

    title(sprintf(...
        'Average FFT - %d RPM',...
        rpm))

    xlim([0 50])

end