import os
import re
import numpy as np
import pandas as pd

from scipy.signal import butter, filtfilt
from scipy.stats import skew, kurtosis

# ==========================================================
# CONFIGURAÇÕES
# ==========================================================

root_folder = "Motores"

fs = 100
lowcut = 5
highcut = 45

window_size = 1000
step = 500

# ==========================================================
# FILTRO BUTTERWORTH
# ==========================================================

def bandpass_filter(signal, fs=100, lowcut=5, highcut=45, order=4):

    nyquist = fs / 2

    low = lowcut / nyquist
    high = highcut / nyquist

    b, a = butter(order, [low, high], btype='band')

    return filtfilt(b, a, signal)


# ==========================================================
# EXTRAÇÃO DE FEATURES
# ==========================================================

def extract_features(signal, fs):

    features = {}

    rms = np.sqrt(np.mean(signal**2))
    mean_abs = np.mean(np.abs(signal))

    features["mean"] = np.mean(signal)
    features["std"] = np.std(signal)
    features["var"] = np.var(signal)

    features["rms"] = rms

    features["max"] = np.max(signal)
    features["min"] = np.min(signal)

    features["peak_to_peak"] = np.ptp(signal)

    features["skewness"] = skew(signal)
    features["kurtosis"] = kurtosis(signal)

    features["crest_factor"] = np.max(np.abs(signal)) / rms
    features["shape_factor"] = rms / mean_abs
    features["impulse_factor"] = np.max(np.abs(signal)) / mean_abs

    rms_sqrt = np.mean(np.sqrt(np.abs(signal)))**2

    features["clearance_factor"] = np.max(np.abs(signal)) / rms_sqrt

    # FFT

    Y = np.fft.rfft(signal)

    freq = np.fft.rfftfreq(len(signal), d=1/fs)

    magnitude = np.abs(Y)

    N = len(signal)

    features["fft_points"] = N
    features["frequency_resolution"] = fs / N
    features["freq_min"] = freq[0]
    features["freq_max"] = freq[-1]
    features["nyquist_frequency"] = fs / 2

    idx_max = np.argmax(magnitude)

    features["dominant_frequency"] = freq[idx_max]
    features["dominant_amplitude"] = magnitude[idx_max]

    features["spectral_energy"] = np.sum(magnitude**2)

    spectral_centroid = np.sum(freq * magnitude) / np.sum(magnitude)

    features["spectral_centroid"] = spectral_centroid

    features["bandwidth"] = np.sqrt(
        np.sum(((freq - spectral_centroid)**2) * magnitude)
        / np.sum(magnitude)
    )

    peak_indices = np.argsort(magnitude)[-3:]
    peak_indices = peak_indices[::-1]

    features["peak1_freq"] = freq[peak_indices[0]]
    features["peak2_freq"] = freq[peak_indices[1]]
    features["peak3_freq"] = freq[peak_indices[2]]

    features["peak1_amp"] = magnitude[peak_indices[0]]
    features["peak2_amp"] = magnitude[peak_indices[1]]
    features["peak3_amp"] = magnitude[peak_indices[2]]

    return features


# ==========================================================
# DATASETS
# ==========================================================

dataset_xyz = []
dataset_long = []
fft_dataset = []

window_counter = 0

# ==========================================================
# LEITURA DOS ARQUIVOS
# ==========================================================

for path, dirs, files in os.walk(root_folder):

    folder_name = os.path.basename(path)

    for file in files:

        if file.endswith(".csv"):

            full_path = os.path.join(path, file)

            print("Processando:", full_path)

            df = pd.read_csv(full_path)

            ax = df["ax"].values
            ay = df["ay"].values
            az = df["az"].values

            # Filtragem
            ax = bandpass_filter(ax, fs, lowcut, highcut)
            ay = bandpass_filter(ay, fs, lowcut, highcut)
            az = bandpass_filter(az, fs, lowcut, highcut)

            # Motor
            motor = re.findall(r'M(\d+)', folder_name)
            motor = int(motor[0]) if motor else None

            # Velocidade
            speed = re.findall(r'V(\d+)', folder_name)
            speed = int(speed[0]) if speed else None

            # Janelamento
            for i in range(0, len(ax) - window_size, step):

                window_counter += 1

                start_sample = i
                end_sample = i + window_size - 1

                start_time_s = start_sample / fs
                end_time_s = end_sample / fs

                center_time_s = (
                    start_time_s + end_time_s
                ) / 2

                window_duration_s = window_size / fs

                x_window = ax[i:i + window_size]
                y_window = ay[i:i + window_size]
                z_window = az[i:i + window_size]

                fx = extract_features(x_window, fs)
                fy = extract_features(y_window, fs)
                fz = extract_features(z_window, fs)

                row = {}

                # Eixo X
                for key, value in fx.items():
                    row["x_" + key] = value

                # Eixo Y
                for key, value in fy.items():
                    row["y_" + key] = value

                # Eixo Z
                for key, value in fz.items():
                    row["z_" + key] = value

                # Informações da janela
                row["window_id"] = window_counter

                row["start_sample"] = start_sample
                row["end_sample"] = end_sample

                row["start_time_s"] = start_time_s
                row["end_time_s"] = end_time_s
                row["center_time_s"] = center_time_s

                row["window_duration_s"] = window_duration_s

                row["motor"] = motor
                row["speed"] = speed

                row["folder"] = folder_name
                row["source_file"] = file

                dataset_xyz.append(row)

                # Dataset longo
                for axis_name, feat in zip(
                        ["X", "Y", "Z"],
                        [fx, fy, fz]):

                    row_long = feat.copy()

                    row_long["axis"] = axis_name

                    row_long["window_id"] = window_counter

                    row_long["start_sample"] = start_sample
                    row_long["end_sample"] = end_sample

                    row_long["start_time_s"] = start_time_s
                    row_long["end_time_s"] = end_time_s
                    row_long["center_time_s"] = center_time_s

                    row_long["window_duration_s"] = window_duration_s

                    row_long["motor"] = motor
                    row_long["speed"] = speed

                    row_long["folder"] = folder_name
                    row_long["source_file"] = file

                    dataset_long.append(row_long)

                # Dataset FFT
                for axis_name, signal_window in zip(
                        ["X", "Y", "Z"],
                        [x_window, y_window, z_window]):

                    Y = np.fft.rfft(signal_window)

                    freq = np.fft.rfftfreq(
                        len(signal_window),
                        d=1/fs
                    )

                    magnitude = np.abs(Y)

                    for f, amp in zip(freq, magnitude):

                        fft_dataset.append({

                            "window_id": window_counter,

                            "axis": axis_name,

                            "start_sample": start_sample,
                            "end_sample": end_sample,

                            "start_time_s": start_time_s,
                            "end_time_s": end_time_s,
                            "center_time_s": center_time_s,

                            "window_duration_s": window_duration_s,

                            "frequency_hz": f,

                            "amplitude": amp,

                            "motor": motor,
                            "speed": speed,

                            "folder": folder_name,
                            "source_file": file

                        })


# ==========================================================
# DATAFRAMES
# ==========================================================

df_xyz = pd.DataFrame(dataset_xyz)

df_long = pd.DataFrame(dataset_long)

df_fft = pd.DataFrame(fft_dataset)

# ==========================================================
# DATASET X
# ==========================================================

x_columns = [c for c in df_xyz.columns if c.startswith("x_")]

x_columns += [
    "window_id",
    "start_sample",
    "end_sample",
    "start_time_s",
    "end_time_s",
    "center_time_s",
    "window_duration_s",
    "motor",
    "speed",
    "folder",
    "source_file"
]

df_x = df_xyz[x_columns]

# ==========================================================
# DATASET Y
# ==========================================================

y_columns = [c for c in df_xyz.columns if c.startswith("y_")]

y_columns += [
    "window_id",
    "start_sample",
    "end_sample",
    "start_time_s",
    "end_time_s",
    "center_time_s",
    "window_duration_s",
    "motor",
    "speed",
    "folder",
    "source_file"
]

df_y = df_xyz[y_columns]

# ==========================================================
# DATASET Z
# ==========================================================

z_columns = [c for c in df_xyz.columns if c.startswith("z_")]

z_columns += [
    "window_id",
    "start_sample",
    "end_sample",
    "start_time_s",
    "end_time_s",
    "center_time_s",
    "window_duration_s",
    "motor",
    "speed",
    "folder",
    "source_file"
]

df_z = df_xyz[z_columns]

# ==========================================================
# EXPORTAÇÃO
# ==========================================================

df_xyz.to_csv(
    "features_dataset_xyz.csv",
    index=False
)

df_x.to_csv(
    "features_dataset_x.csv",
    index=False
)

df_y.to_csv(
    "features_dataset_y.csv",
    index=False
)

df_z.to_csv(
    "features_dataset_z.csv",
    index=False
)

df_long.to_csv(
    "features_dataset_long_format.csv",
    index=False
)

df_fft.to_csv(
    "fft_dataset.csv",
    index=False
)

print("\nArquivos gerados com sucesso!\n")

print("XYZ :", df_xyz.shape)
print("X   :", df_x.shape)
print("Y   :", df_y.shape)
print("Z   :", df_z.shape)
print("LONG:", df_long.shape)
print("FFT :", df_fft.shape)