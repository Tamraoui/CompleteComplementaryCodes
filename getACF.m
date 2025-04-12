%--- Brief :
    % Compute the auto correlation function of the sequences in matrix M
    % each row of the matrix is a sequence

function [cor] = getACF(M)
    cor=xcorr(M(1,:));
    for i=2:size(M,1)
        cor=cor+xcorr(M(i,:));
    end
end