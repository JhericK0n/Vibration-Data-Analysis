# 📊 Vibration Analysis for Electric Motors using Exploratory Data Analysis and Machine Learning

## 📌 Overview

This project investigates vibration signals acquired from electric motors operating under different conditions, aiming to support predictive maintenance applications through data-driven approaches.

The work is developed within the context of Industry 4.0 and Condition-Based Maintenance (CBM), combining traditional vibration analysis techniques with Machine Learning-oriented feature extraction. The first stage of the project focuses on data acquisition, quality assessment, exploratory data analysis (EDA), statistical feature extraction, and frequency-domain analysis.

The final objective is to build a robust dataset capable of supporting fault classification and predictive maintenance models for rotating electrical machines.

---

## 🎯 Research Objective

The main objective of this work is to transform raw vibration signals acquired through IoT-based sensing systems into meaningful information capable of identifying operating conditions and fault-related patterns in electric motors.

The study investigates whether statistical and spectral features extracted from vibration signals can provide sufficient discriminatory information for future Machine Learning applications.

---

## ⚙️ Experimental Setup

### Electric Motors

Two different motors were analyzed:

#### Motor 1 – Single-Phase Motor (Unbalanced)

* Type: Single-phase induction motor
* Operating conditions:

  * 1260 RPM
  * 1320 RPM
  * 1500 RPM
* Fault condition:

  * Unbalance

#### Motor 2 – Three-Phase Motor (Healthy)

* Type: Three-phase induction motor
* Operating condition:

  * 1735 RPM
* Condition:

  * Healthy

---

### Data Acquisition System

* Sensor: Triaxial accelerometer
* Measured axes:

  * X-axis
  * Y-axis
  * Z-axis
* Sampling frequency:

  * 100 Hz
* File duration:

  * 50 seconds
* File format:

  * CSV

Each CSV file contains:

```text
t, ax, ay, az
```

Where:

* t = time (s)
* ax = acceleration in X-axis
* ay = acceleration in Y-axis
* az = acceleration in Z-axis

---

## 📂 Dataset Structure

```text
motors/
│
├── M1_1260/
│   ├── *.csv
│
├── M1_1320/
│   ├── *.csv
│
├── M1_1500/
│   ├── *.csv
│
├── M2_1735_Saudavel/
│   ├── *.csv
```

### Number of Files

| Condition                  | Files |
| -------------------------- | ----- |
| M1 – 1260 RPM (Unbalanced) | 40    |
| M1 – 1320 RPM (Unbalanced) | 76    |
| M1 – 1500 RPM (Unbalanced) | 70    |
| M2 – 1735 RPM (Healthy)    | 26    |

**Total files:** 212

Each file contains approximately 50 seconds of vibration data.

---

## 📁 Repository Structure

```text
.
├── motors/
│
├── Exploratory_Analysis.m
├── Load_01_A11_Data.m
├── Load_02_A11_Data.m
├── FFT.m
├── FFT_only_Equipament.m
├── quality.m
├── analiseDeDados.py
│
├── README.md
```

---

## 🛠️ Scripts Description

### Exploratory_Analysis.m

Performs the complete exploratory analysis:

* Statistical analysis
* Histograms
* Boxplots
* Correlation matrix
* Feature extraction
* Feature space visualization

---

### Load_01_A11_Data.m

Main MATLAB script responsible for:

* Loading all vibration files
* Reading CSV data
* Organizing datasets
* Extracting statistical features
* Generating feature tables

Extracted features:

* RMS
* Standard Deviation
* Kurtosis
* Skewness
* Peak
* Peak-to-Peak
* Energy

---

### Load_02_A11_Data.m

Additional preprocessing and feature manipulation routines.

Used for:

* Dataset organization
* Feature verification
* Supporting Machine Learning preparation

---

### FFT.m

Computes average FFT spectra for all operating conditions.

Features:

* Frequency-domain analysis
* Rotational frequency identification
* Harmonic analysis

Reference markers:

* 1/3× rotational frequency
* 1/2× rotational frequency
* 1× rotational frequency
* 2× rotational frequency
* 3× rotational frequency

---

### FFT_only_Equipament.m

Generates FFT analysis for individual equipment conditions.

Used to investigate:

* Dominant frequencies
* Harmonic behavior
* Spectral signatures

---

### quality.m

Data quality assessment routines.

Evaluates:

* Missing values
* Signal consistency
* Outliers
* Statistical anomalies
* Data integrity

---

### analiseDeDados.py

Python-based support analysis.

Functions may include:

* Statistical evaluation
* Dataset validation
* Data visualization
* Future Machine Learning experiments

---

## 🔍 Exploratory Data Analysis (EDA)

The exploratory analysis was performed in both time and frequency domains.

### Time-Domain Analysis

The following techniques were applied:

* Signal visualization
* Statistical characterization
* Histograms
* Boxplots
* Outlier detection

Key findings:

* Approximately stationary behavior
* Presence of outliers
* Different vibration levels among classes
* Non-Gaussian distributions

---

### Frequency-Domain Analysis

FFT analysis revealed:

* Dominant rotational frequencies
* Harmonic components
* Distinct spectral signatures among classes

Rotational frequencies:

| Condition | RPM  | Rotational Frequency |
| --------- | ---- | -------------------- |
| 1260 RPM  | 1260 | 21.0 Hz              |
| 1320 RPM  | 1320 | 22.0 Hz              |
| 1500 RPM  | 1500 | 25.0 Hz              |
| Healthy   | 1735 | 28.9 Hz              |

The dominant spectral peaks closely match the theoretical rotational frequencies, validating the acquisition system and sensor measurements.

---

## 📊 Feature Engineering

To prepare the dataset for Machine Learning applications, raw vibration signals were transformed into representative statistical descriptors.

Extracted features include:

| Feature      | Description              |
| ------------ | ------------------------ |
| RMS          | Signal energy level      |
| STD          | Signal dispersion        |
| Kurtosis     | Impulsiveness indicator  |
| Skewness     | Distribution asymmetry   |
| Peak         | Maximum amplitude        |
| Peak-to-Peak | Total amplitude range    |
| Energy       | Overall vibration energy |

---

## 📈 Feature Correlation Analysis

A correlation matrix was generated to evaluate dependencies among features.

Main observations:

* Strong correlation between RMS and Energy
* Strong correlation between STD and Peak-to-Peak
* Moderate correlation between Peak and Peak-to-Peak
* Low correlation for Kurtosis and Skewness

These results indicate the presence of both redundant and complementary information within the dataset.

---

## 🎯 Feature Space Analysis

A two-dimensional feature space was generated using:

```text
RMS × Kurtosis
```

The analysis revealed:

* Clear separation between healthy and faulty conditions
* Progressive increase in RMS with rotational speed
* Potential class separability
* Preliminary evidence supporting Machine Learning feasibility

---

## ⚠️ Challenges Identified

During Stage 1, the following challenges were observed:

* Measurement noise
* Presence of outliers
* Class imbalance
* Spectral variability
* Feature redundancy

These issues will be addressed in the next stage through preprocessing and feature selection techniques.

---

## 🚀 Next Steps (Stage 2)

The next stage of the project will focus on:

### Data Preprocessing

* Signal filtering
* Normalization
* Outlier treatment

### Feature Selection

* Correlation analysis
* Redundancy reduction
* Dimensionality reduction

### Machine Learning

Potential algorithms:

* Support Vector Machine (SVM)
* Random Forest
* K-Nearest Neighbors (KNN)
* Decision Trees
* Neural Networks

Target variable:

```text
Motor Condition
```

Classes:

* 1260 RPM Unbalanced
* 1320 RPM Unbalanced
* 1500 RPM Unbalanced
* 1735 RPM Healthy

---

## 🧠 Scientific Contributions

This project contributes to:

* Vibration signal analysis
* Predictive maintenance research
* Industry 4.0 applications
* Condition monitoring systems
* Machine Learning for rotating machinery diagnostics

The work also serves as part of an ongoing Master's Degree research project in Electrical Engineering.

---

## 🛠️ Technologies Used

* MATLAB
* Python
* Signal Processing
* FFT Analysis
* Statistical Analysis
* Feature Engineering
* Machine Learning (future work)

---

## 📎 Author

**Heric Santos Pereira**

Electrical Engineer

Master's Degree Research – Electrical Engineering

Brazil
