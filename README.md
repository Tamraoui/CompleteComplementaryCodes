# Complete Complementary Codes for Coded Excitation Ultrasound Imaging

This repository contains the MATLAB code to generate **Complete Complementary Codes (CCC)** as described in the following paper:

**Tamraoui, M., Bernard, A., Roux, E., & Liebgott, H.**  
*Complementary Coded Multiplane Wave Sequences for SNR Increase in Ultrafast Power Doppler Ultrasound Imaging*  
IEEE Transactions on Ultrasonics, Ferroelectrics, and Frequency Control.

---

## Overview

This work introduces **MPWI-CCC**, a novel Multi-Plane Wave Imaging technique that uses Complete Complementary Codes (CCC) to enhance the **SNR** and **contrast** in ultrafast power Doppler ultrasound imaging. These codes are used to modulate quasi-simultaneously transmitted tilted plane waves and ensure perfect separation upon decoding due to their ideal correlation properties.

The CCC used here are defined as \((N, N, MN/P)\)-CCC, and allow control over the code length.

---

## CCC Correlation Properties

The figures below illustrate the ideal correlation properties of a (4,4,4)-CCC sequence set.

### Auto-Correlation
![Auto-Correlation of CCC](./img/correlations_ccc.png)

### Cross-Correlation
![Cross-Correlation of CCC](./img/crosscorrelationccc.png)

---

## Repository Contents

- `demoCorrelations.m` – MATLAB script to generate CCC sequences and demonstrate their correlation properties.
- `demoGenMPWI3Cwaveforms.m` – Field II example script demonstrating MPWI-CCC.
- `DAS/` – Folder containing beamforming codes.
- `functions/` – All the matlab function are here.
  
---
