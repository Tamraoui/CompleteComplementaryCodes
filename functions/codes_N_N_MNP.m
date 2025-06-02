
% this function generetes a set of complemete complementary sequences
% --- INPUTS : 
    % M : Help controls the length of the sequences
    % N : Number of sequences in each set
    % L : Length of each sequence
% --- OUTPUT : 
    % sets : Sets of complete complementray sequences as cell array: each
    % cell reprsent a set
% Version 1.0 
% Date : 13/06/2022

function [sets] = codes_N_N_MNP(M,N,L)

    if(M>N)
        error('M should be less than or equal to N');
    end
    if(mod(N*M,L)~=0)
        error('L must be chosen so that P is an integer.');
    end
    % calculate P based on the disered length (L) : much easier this way
    P=M*N/L;
    
    if(mod(N,P)~=0)
        error('L must be chosen so that P should devide into N.');
    end
    if(mod(N/P,M)~=0)
        error('M should devide into N/P');
    end
    

    N_P=N/P;
    MN_P=M*N/P;
    Nt=M;

    B=hadamard(M);
    C=hadamard(N_P);
    
    D=[];
    for i=1:N_P/M
        H=hadamard(N_P);
        An=H(:,1+(i-1)*M:i*M);
        D=[D;kron(B,C)*diag(An(:))];
    end
    CCCs=cell(1,N_P);
    for i=1:N_P
        S=zeros(N_P,MN_P);
        for k=1:N_P
            S(k,:)=D(k+(i-1)*N_P,:);
        end
        CCCs{i}=S;
    end
    E=hadamard(P);
    
    Sp=[];
    for i=1:numel(CCCs)
        AColumnVector = reshape(CCCs{i}', [], 1)';
        Sp=[Sp;AColumnVector];
    end
    Sp=kron(E,Sp);
    
    sets=cell(1,N);
    for i=1:size(Sp,1)
        M=reshape(Sp(i,:),MN_P,N)';
        sets{i}=M;
    end
end