%% generate new populations by three operators
%% =================================================================
function [P,A,M] = Operators_f(I,J,K,N2,N_rv,DM,NRC,Pm,Pg,PP,AA,MM,Z,M_gb)
Cr= floor((1-Pm)*N_rv);
Gs= floor(Pg*N_rv);
[P,A,M] = Roulette_f(PP,AA,MM,Z,N_rv);
%% Crossover Operator
for i = 1:2:Cr
    [A(i,:),A(i+1,:)] = Crossover_f(I,J,P(i,:),P(i+1,:),A(i,:),A(i+1,:));
    M(i,:) = NRRC_f(I,J,K,N2,DM,NRC,P(i,:),A(i,:),M(i,:));
    M(i+1,:) = NRRC_f(I,J,K,N2,DM,NRC,P(i+1,:),A(i+1,:),M(i+1,:));
end
%% Mutation Operator
for i = Cr+1:N_rv
    [P(i,:),A(i,:),M(i,:)] = Mutation_f(I,J,P(i,:),A(i,:),M(i,:));
end
%% Greedy Search Operator
n=1;
while n <= Gs
    i = randi(N_rv);
    m = AssignMode_f(I,J,P(i,:),A(i,:),M_gb);
    M(i,:) = m;
    n = n+1;
end