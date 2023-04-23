function twostepMag = twostepsnr(x_blocks,noise_approx,fs)
    n_blck = size(x_blocks,2);
    block_size = size(x_blocks,1);
    window = hann(block_size);
    nfft = 2*block_size;
    prev_block = zeros(nfft,1);
    beta = 0.99;
    twostepMag = zeros(nfft,n_blck);

    for i = 1:n_blck
        [f, Xabs, Xphase, Xre, Xim] = computeSpectrum(window.*x_blocks(:,i), fs,nfft);
        postSnr = ((Xabs.^2) ./ noise_approx) -1 ;
        postSnr=max(postSnr,0.1); %Limiting SNR to prevent distortion

        % Calculating prioriSnr
        priorSnr = beta*((prev_block.^2)./noise_approx) + (1-beta) * postSnr;
        H = priorSnr./(priorSnr+1);
        updateMag = H.*Xabs;

        % Two step procedure

        ndsnr = (updateMag).^2 ./ noise_approx;
        Hnd = ndsnr./(ndsnr +1);
        Hnd =max(Hnd,0.15);
        Hnd = gaincontrol(Hnd,(nfft/2));
        updateMag = Hnd .* Xabs;
        spectwPhase = updateMag.*exp(1i*Xphase);
        prev_block = abs(updateMag);
        twostepMag(:,i) = spectwPhase;
    end


end