%% Lab 1: Image as a 2D Signal (Sampling, Quantization, Histograms, Enhancement)
% If 'peppers.png' isn't available, this falls back to 'cameraman.tif'.

clear; close all; clc;

%% 0) Load and inspect an image
if exist('peppers.png','file')
    I_rgb = imread('peppers.png');
else
    I_rgb = repmat(imread('cameraman.tif'),1,1,3); % fallback as 3-ch
end
figure, imshow(I_rgb), title('Original RGB');

% Convert to grayscale (luminance)
if size(I_rgb,3) == 3
    I = rgb2gray(I_rgb);
else
    I = I_rgb;
end
figure, imshow(I), title('Grayscale');

% Basic info
fprintf('Class: %s | Range: [%g, %g] | Size: %d x %d\n', ...
    class(I), double(min(I(:))), double(max(I(:))), size(I,1), size(I,2));

%% 1) Quantization and dynamic range
% 8-bit -> 6-bit -> 4-bit examples (uniform scalar quantization)
I8  = I;                                   % 8 bits (0..255)
I6  = uint8(floor(double(I)/4)*4);         % 6 bits: step = 2^(8-6) = 4
I4  = uint8(floor(double(I)/16)*16);       % 4 bits: step = 2^(8-4) = 16

figure, montage({I8, I6, I4}, 'Size', [1 3])
title('Quantization: 8-bit vs 6-bit vs 4-bit');

%% 2) Histogram and contrast stretching
figure;
subplot(2,1,1), imhist(I), title('Histogram (original)');

I_norm = mat2gray(I);                       % scale to [0,1]
% Mid-range stretch: move [0.2 0.8] -> [0 1]
I_stretch = imadjust(I_norm, [0.2 0.8], [0 1]);

subplot(2,1,2), imhist(I_stretch), title('Histogram (stretched)');

figure, montage({im2uint8(I_norm), im2uint8(I_stretch)}, 'Size',[1 2])
title('Original (normalized) | Contrast-stretched');

%% 3) Gamma correction (nonlinear amplitude scaling)
gamma_low = 0.6;  % <1 brightens
gamma_high = 1.6; % >1 darkens
I_gamma_low  = imadjust(I_norm, [], [], gamma_low);
I_gamma_high = imadjust(I_norm, [], [], gamma_high);

figure, montage({I, im2uint8(I_gamma_low), im2uint8(I_gamma_high)}, 'Size',[1 3])
title(sprintf('Gamma: original | \\gamma=%.1f | \\gamma=%.1f', gamma_low, gamma_high));

%% 4) Sampling and aliasing (downsample then upsample)
scale = 0.1;  % keep 10% in each dimension
I_small = imresize(I, scale, 'nearest');          % naive downsampling
I_back  = imresize(I_small, size(I), 'nearest');  % upsample back

figure, montage({I, I_small, I_back}, 'Size',[1 3])
title('Original | Aggressively downsampled | Upscaled back (aliasing artifacts)');

%% 5) Optional: Moiré demo with synthetic high-frequency pattern
% Create a high-frequency sinusoidal grating, then resample to show moiré.
N = 512;
[x,y] = meshgrid(linspace(0,1,N));
freq = 40; % cycles across the image (try 20,40,60 to vary)
grating = 0.5 + 0.5*sin(2*pi*freq*x);
G = im2uint8(grating);

G_small = imresize(G, 0.2, 'nearest');
G_back  = imresize(G_small, [N N], 'nearest');

figure, montage({G, G_small, G_back}, 'Size',[1 3])
title('Synthetic grating | Downsampled | Upscaled back (moiré/aliasing)');

% Bonus: compare resampling filters
G_back_bicubic = imresize(G_small, [N N], 'bicubic');
figure, montage({G_back, G_back_bicubic}, 'Size',[1 2])
title('Nearest vs Bicubic (moiré mitigation)');
