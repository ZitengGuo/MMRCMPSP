%% Generate initial population randomly
%% =================================================================
function [P,A,M] = Random_f(I,J,K)
P = randperm(I);   % initialize Project
AA = [];
M = zeros(1,sum(J));
for i = 1:I
    AA = [AA,randperm(J(P(i)))];  % initialize Acitivity
end
A = AA;
for i = 1:sum(J)
    M(i) = randperm(K,1); % initialize Mode
end