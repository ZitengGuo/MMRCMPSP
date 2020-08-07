%% Roulette Wheel Seletion
%% =================================================================
function [Parent_P,Parent_A,Parent_M] = Roulette_f(P,A,M,Z,N)
Parent_P = P;
Parent_A = A;
Parent_M = M;
%% Normalization
Z_max = max(Z);
Z_min = min(Z);
Z_norm = (Z - Z_min) / (Z_max - Z_min + 1);
prob = Z_norm / sum(Z_norm);
cum_prob = cumsum(prob);
%% Selection
for i = 1:N
    select_i = find(cum_prob > rand,1);
    Parent_P(i,:) = P(select_i,:);
    Parent_A(i,:) = A(select_i,:);
    Parent_M(i,:) = M(select_i,:);
end