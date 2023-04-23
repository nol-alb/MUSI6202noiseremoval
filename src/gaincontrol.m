function NewGain = gaincontrol(Gain,signalblocksize)
% 1- The time-duration of noisy speech frame is equal to L1 samples.

% the time-duration L2 of the equivalent
%       impulse response g(n) should be chosen such that 
% 
% Ltot = L1 + L2 -1 <= NFFT 
% L2 <= NFFT+1-Ll
% L2 <= Ll+1
% L2=NFFT/2=L1

    mGain=mean(Gain.^2);
    nfft=length(Gain);
    L2=signalblocksize;
    win=hamming(L2);
    ImpulseR=real(ifft(Gain,nfft));
    
    % Resizing the impulse response
    editImpulseR = [ImpulseR(1:floor(L2/2)+1).*win(floor(L2/2)+1:L2); zeros(nfft-L2,1); ImpulseR(nfft-floor(L2/2)+1:nfft).*win(1:floor(L2/2))];
    % Back to frequency
    NewGain=abs(fft(editImpulseR,nfft));
    meanNewGain=mean(NewGain.^2);
    NewGain=NewGain*sqrt(mGain/meanNewGain); % normalisation to keep the same energy (if white r.v.)

end

