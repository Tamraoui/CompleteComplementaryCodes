function [out] = bandwidthMatch(sets,params,periods)
    t=(0:1/params.fs:periods/params.f0-1/params.fs);
    pulse = sin(2*pi*params.f0*t);
    pulse=pulse.*hanning(max(size(pulse)))';
    numSets=numel(sets);
    out=cell(1,numSets);
    for i=1:numSets
          out{i}=kron(sets{i},pulse); 
    end
end