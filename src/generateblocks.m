function [t, x_blk] = generateblocks(x, sample_rate_hz, block_size, hop_size) 
    nx = size(x, 1);
    nblk = ceil((nx - block_size)/hop_size) + 1;
    nxp = (nblk - 1) * hop_size + block_size;
    npad = nxp - nx;
    xpad = [x; zeros(npad, 1)];

    blks = 1:nblk;
    blk_starts = (blks - 1) * hop_size;
    sampl = (1:block_size).';
    idxs = blk_starts + sampl;
    x_blk = xpad(idxs);

    t = hop_size/sample_rate_hz * (0:nblk-1).';


end