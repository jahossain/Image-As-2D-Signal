# Image-As-2D-Signal
Q1) Relate bit-depth to visible banding/posterization.
Lower bit-depth increases the quantization step size (e.g., 4-bit ⇒ step 16 gray levels). Large steps collapse nearby intensities to the same value, reducing available tones and producing banding/posterization (visible contour lines in smooth gradients). At 8-bit (step 1), banding is usually imperceptible; at 6-bit (step 4) it may be mild; at 4-bit (step 16) it becomes obvious.

Q2) How does contrast stretching change the histogram and visibility of details?
Contrast stretching remaps an input range (e.g., [0.2, 0.8]) to the full [0,1]. The histogram spreads out (becomes wider) and often flattens within the remapped region, increasing local contrast. Dark/bright details that were previously compressed into a narrow set of bins become more distinguishable. Saturation can occur at the ends if pixels fall outside the selected input window (they pile up at 0 or 1).

Q3) Why does aggressive downsampling cause aliasing (reference Nyquist)?
An image contains spatial frequencies. When you sample on a coarser grid (downsample), the Nyquist limit (half the sampling frequency) drops. Frequencies above this new limit aren’t removed unless you low-pass filter first; they fold into lower frequencies as aliases, producing jagged edges, false patterns, and moiré. Proper procedure: low-pass (antialias) filter before decimation, and prefer higher-quality resamplers on upsampling.
