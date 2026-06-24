# 📊 Vibration Analysis and Unsupervised Machine Learning for Electric Motor Condition Monitoring

## 📌 Overview

This repository contains the implementation and experimental results of a Master's Degree research project focused on vibration analysis and unsupervised Machine Learning techniques for condition monitoring of rotating electrical machines.

The work combines signal processing, feature engineering, dimensionality reduction, clustering algorithms, and anomaly detection methods to investigate hidden structures and operating patterns in vibration signals acquired from electric motors.

The proposed framework is developed within the context of Industry 4.0, Industrial Internet of Things (IIoT), and predictive maintenance applications.

---

## 🎯 Research Objective

The objective of this work is to transform raw vibration signals acquired through IoT-based sensing systems into meaningful information capable of revealing operating patterns and potential anomalous behaviors in electric motors.

The study investigates the effectiveness of feature extraction and unsupervised Machine Learning techniques in condition monitoring applications where labeled fault data are limited or unavailable.

---

## ⚙️ Experimental Setup

### Motor Characteristics

* Supply voltage: 127 Vac
* Frequency: 60 Hz
* Number of poles: 6
* Nominal speed: 1200 rpm
* Rotational frequency: ≈ 20 Hz

### Data Acquisition System

* Sensor: Triaxial accelerometer
* Measured axes:

  * X-axis
  * Y-axis
  * Z-axis
* Sampling frequency: 100 Hz
* File format: CSV

Each CSV file contains:

```text
t, ax, ay, az
```

where:

* t → time (s)
* ax → acceleration along X-axis
* ay → acceleration along Y-axis
* az → acceleration along Z-axis

---

## 📂 Dataset Structure

```text
motors/
│
├── M1V1/
│   ├── *.csv
│
├── M1V2/
│   ├── *.csv
│
├── M1V3/
│   ├── *.csv
│
└── ...
```

The dataset contains approximately 204,000 vibration samples acquired under controlled operating conditions.

---

## 📁 Repository Structure

```text
.
├── motors/
│   ├── M1_1260/
│   ├── M1_1320/
│   ├── M1_1500/
│   └── M2_1735_Saudavel/
│
├── dataset/
│   ├── Clusters_PCA_KMeans_DBSCAN.csv
│   ├── features_dataset_long_format.csv
│   ├── features_dataset_x.csv
│   ├── features_dataset_xyz.csv
│   ├── ...
│
├── script/
│   ├── knime
│   │   ├── ,metadata
│   │   ├── Example Workflows
│   │   └── VibrationAnalysis_project
│   │
│   ├── matlab
│   │   ├── 03_raw_signal_exploratory_analysis.m
│   │   ├── 04_feature_exploratory_analysis.m
│   │   ├── 05_individual_motor_fft_analysis.m
│   │   ├── 06_global_fft_analysis.m
│   │   └── 07_data_quality_assessment.m
│   │
│   └── qualityAssessment.m
│       ├── 01_data_preprocessing.py
│       └── 02_data_analysis_preparation.py
│
├── figures/
│
├── results/
│
├── article/
│
└── README.md
```

---

## 🔍 Exploratory Data Analysis

The exploratory analysis was performed in both time and frequency domains.

### Time-Domain Analysis

* Signal visualization
* Histograms
* Boxplots
* Correlation matrix
* Statistical characterization
* Outlier identification

Main findings:

* Approximately stationary behavior;
* Non-Gaussian distributions;
* Presence of outliers;
* Different vibration amplitudes among axes;
* Strong correlation between X and Z directions.

---

### Frequency-Domain Analysis

Fast Fourier Transform (FFT) analysis revealed:

* Dominant frequency around 20 Hz;
* Harmonics near 40 Hz;
* Different spectral responses among axes;
* Distinct vibration signatures.

---

## ⚙️ Feature Engineering

The raw vibration signals were segmented and transformed into representative descriptors.

### Time-Domain Features

* Mean
* RMS
* Standard Deviation
* Peak
* Peak-to-Peak
* Energy
* Kurtosis
* Skewness

### Frequency-Domain Features

* Dominant frequency
* Maximum spectral amplitude
* Spectral energy

These descriptors provide a compact representation of the vibration behavior.

---

## 🧠 Dimensionality Reduction

### Principal Component Analysis (PCA)

PCA is employed to:

* Reduce feature redundancy;
* Improve data visualization;
* Preserve the most informative components;
* Increase computational efficiency.

Evaluation metric:

* Explained Variance Ratio.

---

## 🔵 K-Means Clustering

K-Means is used to investigate the existence of distinct operating patterns.

### Hyperparameters

* Number of clusters (k)
* Number of initializations
* Maximum number of iterations

Evaluation metrics:

* Silhouette Score
* Davies-Bouldin Index

---

## 🔴 DBSCAN Clustering

DBSCAN is employed for:

* Density-based clustering;
* Outlier detection;
* Identification of anomalous behaviors.

### Hyperparameters

* Epsilon (ε)
* Minimum number of samples (MinPts)

Evaluation criteria:

* Number of clusters;
* Noise ratio;
* Stability of clusters.

---

## 📈 Experimental Workflow

```text
Data Acquisition
        ↓
Preprocessing
        ↓
Feature Extraction
        ↓
Normalization
        ↓
PCA
        ↓
K-Means
        ↓
DBSCAN
        ↓
Performance Evaluation
        ↓
Physical Interpretation
```

---

## 📊 Evaluation Metrics

### PCA

* Explained Variance Ratio

### K-Means

* Silhouette Coefficient
* Davies-Bouldin Index

### DBSCAN

* Number of clusters
* Noise ratio
* Cluster stability

---

## 🔬 Scientific Contributions

This work contributes to:

* Condition monitoring of rotating machinery;
* Vibration signal analysis;
* Feature engineering for predictive maintenance;
* Unsupervised Machine Learning applications;
* Industry 4.0 and IIoT systems;
* Data-driven maintenance strategies.

---

## 🚀 Future Work

Future developments include:

* Expansion of the vibration dataset;
* Introduction of fault conditions;
* Comparison with supervised learning approaches;
* Development of intelligent embedded monitoring systems;
* Real-time anomaly detection;
* Digital Twin integration.

---

## 🛠️ Technologies Used

### Programming Languages

* MATLAB
* Python

### Python Libraries

* NumPy
* Pandas
* Matplotlib
* SciPy
* Scikit-learn

### Signal Processing

* FFT
* Statistical Analysis
* Feature Engineering

### Machine Learning

* PCA
* K-Means
* DBSCAN

---

## 📚 Related Topics

* Predictive Maintenance
* Condition Monitoring
* Vibration Analysis
* Machine Learning
* Unsupervised Learning
* Clustering
* Anomaly Detection
* Industry 4.0
* Industrial Internet of Things (IIoT)

---

## 📎 Author

**Heric Santos Pereira**

Electrical Engineer

Master's Degree Student in Electrical Engineering

Federal University of Uberlândia (UFU)

Brazil
