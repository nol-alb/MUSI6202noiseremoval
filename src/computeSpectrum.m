function [f, Xabs, Xphase, Xre, Xim] = computeSpectrum(x, sample_rate_hz , nfft)

    nx = size(x, 1);

    X = fft(x, nfft);
    nX = floor(nfft/2)+1;
    % Two sided
    nxpadded = 2.^nextpow2(nx);
    Xabs = abs(X);
    Xphase = angle(X);
    Xre = real(X);
    Xim = imag(X);

    df = sample_rate_hz/nxpadded;
    f = df * (0:nX-1).';
end