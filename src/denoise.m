function xhat = denoise(y, fs)
% Extract the first three seconds of noise
    noise_only = y(1:3*fs);
%25 millisecond blocks
    block_size = ceil(0.025*fs);
    nfft = 2*block_size;
    % 60% overlap
    noverlap = ceil(0.4*block_size);
% Estimate Noise statistics
    noise_approx = noiseapprox(noise_only, fs, nfft,block_size);

% Generate blocks of noisy signal
    [t, x_blk] = generateblocks(y, fs, block_size, noverlap); 

% Compute STFT and extract phase and magnitude
% Run two step SNR
    twostepMag = twostepsnr(x_blk,noise_approx,fs);
% Regenerate time domain denoised -> set to xhat
    xhat = backtotime(y,twostepMag,noverlap,nfft);


end