function [excitation,CodeUpsampled] = npComplementrayCodes(chip,M,N,L,bm)
    excitation=codes_N_N_MNP(M,N,L);
    if(bm==1)
        [excitation,CodeUpsampled] = bandwidthMatching(excitation,chip);
    end
end