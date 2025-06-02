clc;clear;close all;
% This script demonstrates the autocorrelation and the cross correlation
% properties of CCC

%--- Generate CCC
% Generate 4 sets of 4 sequences of length 8
% M=2 is enough for 8 length sequences
% However if you want 16 bit length M must be set to 4 : codes_N_N_MNP(4,4,16)
CCC=codes_N_N_MNP(2,4,8);

%--- Demo autocorrelation
% plot the ACF of each set
for i=1:numel(CCC)
    figure;
    stem(getACF(CCC{i}));
end

%--- Demo cross-correlation
% calc CCF of set 1 and set 3 for example
ccf = getCCF(CCC{1},CCC{3});
figure;stem(ccf);ylim([-1 1])
