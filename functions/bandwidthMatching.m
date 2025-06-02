function [out,outM] = bandwidthMatching(sets,pulse)
    %t=(0:1/params.fs:periods/params.f0-1/params.fs);
    %pulse = sin(2*pi*params.f0*t);
    %pulse=pulse.*hanning(max(size(pulse)))';
    %load('chip.mat')
    %pulse=chip';
    if(~isrow(pulse))
        pulse=pulse';
    end
    Tpfs = length(pulse); 
    numSets=numel(sets);
    out=cell(1,numSets);
    for i=1:numSets
        
          N=sets{i};
          M=upsample(N',Tpfs);
          M=M(1:end-Tpfs+1,:);
          out{i}=conv2(M,pulse','full')';
          outM{i}=M';
    end
end