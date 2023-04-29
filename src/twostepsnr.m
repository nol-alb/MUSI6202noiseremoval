%{
twostepMagnitude calculation as described in C. Plapous, C. Marro, Laurent Mauuary, and Pascal Scalart, “A two-step noise reduction technique,” 
International Conference on Acoustics, Speech, and Signal Processing
%}

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
        % postSNR equation 
        postSnr = ((Xabs.^2) ./ noise_approx) -1 ;
        postSnr=max(postSnr,0.1); %Limiting SNR to prevent distortion

        % Calculating prioriSnr
        priorSnr = beta*((prev_block.^2)./noise_approx) + (1-beta) * postSnr;
        H = priorSnr./(priorSnr+1);
        % Convolution
        updateMag = H.*Xabs;

        % Two step procedure
        % Use the updated Magnitude to calculate second step priorsnr

        ndsnr = (updateMag).^2 ./ noise_approx;
        % Wiener filter transfer function
        Hnd = ndsnr./(ndsnr +1);
        Hnd =max(Hnd,0.15);
        % Resize to avoid time aliasing
        Hnd = gaincontrol(Hnd,(nfft/2));
        % Convolution
        updateMag = Hnd .* Xabs;
        % reconstruct spectrum using the noisy signal phase
        spectwPhase = updateMag.*exp(1i*Xphase);
        % update the next block
        prev_block = abs(updateMag);
        twostepMag(:,i) = spectwPhase;
    end


end