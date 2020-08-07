%% Constraints Check & Repair 
%% for Successors and NRRC
%% =================================================================
function [A,M] = SFCRP_f(I,J,K,N2,Su,DM,NRC,PP,AA,MM)
%% Successor Constraints Check & Repair
P = PP;
A = AA;
M = MM;
[FC_S,A_N] = Successor_f(I,J,Su,P,A);
num = length(FC_S(FC_S>0));
A = A_N;
while num ~= 0
    [FC_S,A_N] = Successor_f(I,J,Su,P,A);
    num = length(FC_S(FC_S>0));
    A = A_N;
end
%% Non-Renewable Resource Constraints Check & Repair
[M_N] = NRRC_f(I,J,K,N2,DM,NRC,P,A,M);
M = M_N;