%% generate new populations by three operators
%% =================================================================
function [P,A,M] = Operators_f(I,J,K,N2,N,DM,NRC,Pm,PP,AA,MM,Z)
[P,A,M] = Roulette_f(PP,AA,MM,Z,N);
%% Mutation Operator
for i = 1:Pm*N
    [P(i,:),A(i,:),M(i,:)] = Mutation_f(I,J,P(i,:),A(i,:),M(i,:));
end
%% Crossover Operator
for i = Pm*N+1:2:(N-1)
    [A(i,:),A(i+1,:)] = Crossover_f(I,J,P(i,:),P(i+1,:),A(i,:),A(i+1,:));
    M(i,:) = NRRC_f(I,J,K,N2,DM,NRC,P(i,:),A(i,:),M(i,:));
    M(i+1,:) = NRRC_f(I,J,K,N2,DM,NRC,P(i+1,:),A(i+1,:),M(i+1,:));
end