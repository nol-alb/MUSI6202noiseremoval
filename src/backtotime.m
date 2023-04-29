function xtime = backtotime(x,x_spec_block,hop_size,nfft)
    length = size(x,1);
    block_size = size(x_spec_block,1);
    nblk = size(x_spec_block,2);
    xtime = zeros(size(x,1)+nfft,1);
    normFactor = 1/(hop_size/nblk);

    % Read from blocks based on hop size
    for blk = 0:nblk-1
        start = (blk*hop_size)+1;
        xtime(start:start+nfft-1) = xtime(start:start+nfft-1) + real(ifft(x_spec_block(:,blk+1),nfft))/normFactor;
    end
    % Normalization to avoid insane peaks
    xtime = xtime * max(abs(x))/max(abs(xtime));
    xtime = xtime(1:length);

end