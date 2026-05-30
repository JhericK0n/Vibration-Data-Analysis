import pandas as pd
import numpy as np
from scipy.stats import kurtosis

# =========================
# 1. CARREGAR DADOS
# =========================
data = pd.read_csv("dados_vibracao.csv")

ax = data["ax"].values
ay = data["ay"].values
az = data["az"].values

# Magnitude (opcional mas recomendado)
signal = np.sqrt(ax**2 + ay**2 + az**2)

# =========================
# 2. PARÂMETROS
# =========================
fs = 1000                 # frequência de amostragem (ajuste conforme ESP32)
window_size = fs * 1      # 1 segundo por janela
step = window_size // 2   # 50% overlap (recomendado)

# =========================
# 3. LISTAS DE SAÍDA
# =========================
features = []
window_id = []

# =========================
# 4. SLIDING WINDOW CORRETO
# =========================
i = 0

for start in range(0, len(signal) - window_size, step):

    end = start + window_size
    segment = signal[start:end]

    # garantir tamanho correto
    if len(segment) != window_size:
        continue

    # =========================
    # 5. FEATURES NO TEMPO
    # =========================
    rms = np.sqrt(np.mean(segment**2))
    peak = np.max(np.abs(segment))
    var = np.var(segment)
    kurt = kurtosis(segment)

    # =========================
    # 6. FFT (FREQUÊNCIA)
    # =========================
    Y = np.fft.fft(segment)
    freqs = np.fft.fftfreq(len(Y), d=1/fs)

    half = len(Y) // 2
    Y_pos = np.abs(Y[:half])
    f_pos = freqs[:half]

    freq_dom = f_pos[np.argmax(Y_pos)]

    # =========================
    # 7. ARMAZENAR RESULTADOS
    # =========================
    features.append([rms, peak, var, kurt, freq_dom])
    window_id.append(i)

    i += 1

# =========================
# 8. DATAFRAME FINAL
# =========================
df_features = pd.DataFrame(features, columns=[
    "RMS",
    "Pico",
    "Variancia",
    "Kurtosis",
    "FreqDominante"
])

df_features.insert(0, "Janela", window_id)

# =========================
# 9. EXPORTAR PARA EXCEL
# =========================
df_features.to_excel("features_vibracao.xlsx", index=False)

print("✔ Dataset gerado com sucesso!")
print(f"Total de janelas: {len(df_features)}")