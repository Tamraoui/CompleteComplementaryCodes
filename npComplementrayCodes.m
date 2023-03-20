function [excitation] = npComplementaryCodes(params,periods,M,N,L,bm)
    excitation=codes_M_N_MNP(M,N,L);
    if(bm==1)
        [excitation] = bandwidthMatch(excitation,params,periods);
    end
end