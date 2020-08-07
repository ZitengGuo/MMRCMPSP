%% Initialization Phase
%% =================================================================
function [P,A,M,Z] = Initialization_f(I,J,K,N,N1,N2,Su,DM,RRC,NRC,URUC,URIC,UNRUC,RD,DD,FP,UB,UP)
P = zeros(N,I);
A = zeros(N,sum(J));
M = zeros(N,sum(J));
Z = zeros(N,1);
n = 1;
while  n <= N
    fprintf("种群子代："),disp(n)
    [P(n,:),A(n,:),M(n,:)] = Random_f(I,J,K);
    % Feasibility check & Repair
    [A(n,:),M(n,:)] = SFCRP_f(I,J,K,N2,Su,DM,NRC,P(n,:),A(n,:),M(n,:));
    % Calculate fitness of population
    Z(n) = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,UNRUC,RD,DD,FP,...
        UB,UP,P(n,:),A(n,:),M(n,:));
    % Deal with the same population
    n = n + SameP_f(P(1:n-1,:),A(1:n-1,:),M(1:n-1,:),Z(1:n-1),...
                    P(n,:),A(n,:),M(n,:),Z(n));
end