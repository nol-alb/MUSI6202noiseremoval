function noise_approx = noiseapprox(noise_only, fs, nfft, block_size)

 nsum = zeros(nfft,1);
 len_noise = length(noise_only);
 win = hanning(block_size);
 [t, noise_blk] = generateblocks(noise_only, fs, block_size, block_size); 
 nblk = size(noise_blk,2);
 noise_fft_blk = zeros(nfft,nblk);

 for blk = 1:nblk
     nwin = noise_blk(:,blk).*win;
     noise_fft_blk(:,blk) = abs(fft(nwin,nfft)).^2;
 end
 nsum = sum(noise_fft_blk,2);
 noise_approx = nsum/nblk;

    %noise_approx = pwelch(noise_only, hann(nfft, "periodic"), noverlap, nfft, fs, "twosided");
end