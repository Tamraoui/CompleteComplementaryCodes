%--- Brief :
    % Compute the cross correlation function of the two sets
    % each row of the matrix is a sequence

function [crox] = getCCF(set1,set2)
        n1=size(set1,1);
        n2=size(set2,1);
        if(n1~=n2)
            error('sequences do not have the same size');
        end
        crox=xcorr(set1(1,:),set2(1,:));
        for i=2:n1
            crox=crox+xcorr(set1(i,:),set2(i,:));
        end
end