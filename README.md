# RTL-Design-of-IIR-Filter-as-Digital-Envelope-Detector

## 📌 Overview
This project implements a **Digital Envelope Detector** in Verilog using a **first-order IIR Low-Pass filter**. The detector tracks the envelope (magnitude variation) of an input signal, which is useful in RF/communication systems, AM demodulation, and signal detection.

The design uses **Q1.15 fixed-point arithmetic** for efficient hardware implementation.

---
## Block Diagram

![Block Diagram](https://github.com/XACKIES/RTL-Design-of-IIR-Filter-as-Digital-Envelope-Detector/blob/main/Doc/Block_Diagram.png)


## Simulation Result
![Sim_Result](https://github.com/XACKIES/RTL-Design-of-IIR-Filter-as-Digital-Envelope-Detector/blob/main/Doc/Sim_Result.png)



---
## ⚙️ Module Description
```verilog
module Envelope_Detector #(
    parameter DATA_WIDTH = 32,
    parameter ALPHA = 16'h00FF   // filter coefficient in Q1.15
)(
    input  wire clk,
    input  wire rst_n,           // asynchronous active-low reset
    input  wire signed [DATA_WIDTH-1:0] signal_in,
    output reg  [DATA_WIDTH-1:0] envelope_out
);
```

### 🔹 Key Steps
1. **Absolute value** of input (`|x[n]|`)
2. **Recursive filter**:

```math
y[n] = (1 - α) · y[n-1] + α · |x[n]|
```

3. **Scaling in Q1.15** fixed-point  
4. Output is updated every clock cycle

---

## 🧮 Mathematical Proof

### 1. Analog RC Low-Pass
The classical analog RC low-pass filter is:

```math
τ · dy(t)/dt + y(t) = x(t),   where  τ = RC
```

Transfer function:

```math
H(s) = 1 / (1 + τs)
```

### 2. Bilinear Transform
Applying the bilinear transform `s → (2/T) · (1 - z⁻¹)/(1 + z⁻¹)`:

```math
H(z) = (1 + z⁻¹) / [(1 + z⁻¹) + (2τ/T)(1 - z⁻¹)]
```

Which leads to the **difference equation**:

```math
y[n] = (1 - α) · y[n-1] + α · x[n]
```

Where:

```math
α = T / (T + 2τ)
```

---

## 📡 Applications

- **AM Demodulation**  
  Extracting the audio envelope from an AM radio carrier.
  
- **RF Energy Detection**  
  Measuring instantaneous signal strength in SDR/communication systems.
  
- **ADS-B / Packet Detection**  
  Used in avionics and SDR-based receivers to detect signal presence before decoding.
  
- **Audio Processing**  
  Envelope tracking for compressors, limiters, and dynamics processors.

- **FM / FSK Demodulation (with preprocessing)**  
  In FM or FSK systems, the instantaneous frequency can be converted into an amplitude-varying signal using a frequency discriminator or differentiator.  
  After this conversion, an envelope detector can be applied to recover the baseband information (e.g., audio for FM or binary data for FSK).

---

## 🚀 Future Extensions
- **Adaptive ALPHA**: Dynamically adjust filter speed based on signal conditions.  
- **Multi-Channel Envelope Detector**: For MIMO or array processing.  
- **Integration with FFT-based Spectrum Analysis**: Envelope outputs could feed into energy detectors for wireless protocols.  
- **FM / FSK Demodulation Support**: Combine with frequency discriminators or bandpass filter banks to extend envelope detection toward FM audio demodulation or non-coherent FSK data demodulation.  
- **FPGA/ASIC Implementation**: Optimized for low-power hardware systems in SDR and IoT devices.  

---

