%{
As proposed by Plapous et al. 

Function used to avoid time aliasing 
    L1 -> length of block
    L2 -> length of transfer function
    convOutput -> L1+L2-1
since NFFT -> 2*L1
 convOutput = L1 + L2 -1 < = NFFT 
       ->  L2 <= NFFT+1-Ll
       ->  L2 <= NFFT/2+1
       ->  L2 <= L1
%}


function NewGain = gaincontrol(Gain,signalblocksize)
        

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
    NewGain=NewGain*sqrt(mGain/meanNewGain); % normalisation to keep the same energy

end

