% --- By Mohamed TAMRAOUI. Don't you dare remove my name !
% this function generetes a set of complemete complementary sequences
% --- INPUTS : 
    % M : Number of sets
    % N : Number of sequences in each set
    % L : Length of each sequence
% --- OUTPUT : 
    % sets : Sets of complete complementray sequences
% Version 1.0 
% Date : 13/06/2022

function [sets] = codes_M_N_MNP(M,N,L)

    if(M>N)
        error('M should be less than or equal to N');
    end
    if(mod(N*M,L)~=0)
        error('L must be chosen so that P is an integer.');
    end
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
    % first seed matrix
    I=eye(Nt/2);
    z=zeros(size(I));
    Pn=[z I;I z];
    Qn=eye(Nt);
    H= hadamard(Nt);
    HB=Pn*H*Qn;
    % second seed matrix
    Nt=N_P;
    Hada1=hadamard(Nt);
    GolayDia=diag(generate_golay(log2(Nt)));
    HC=Hada1*GolayDia;
    B=HB;%hadamard(M);
    %B=hadamard(M);
    C=HC;%hadamard(N_P);
    %C=hadamard(N_P);
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




function [a,b] = generate_golay(N)
% [a,b] = generate_golay(N)
%
% Generate the Golay codes a and b with length 2^N.
%
% Then write them to disk as golayA.wav and golayB.wav.


% These initial a and b values are Golay
a = [1 1];
b = [1 -1];

% Iterate to create a longer Golay sequence
while (N>1)
    olda = a;
    oldb = b;
    a = [olda oldb];
    b = [olda -oldb];

    N = N - 1;
end
end
