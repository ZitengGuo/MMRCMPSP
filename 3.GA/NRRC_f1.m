%% Get the consumption of the different NRR for each activity
%% Get the total consumption of the different NRR
%% =================================================================
function [c,nrc] = NRRC_f1(p,a,m,N2,J,K,DM)
c = zeros(N2,J(p));
nrc = zeros(1,N2);
for j = 1:J(p)
    for k = 1:N2
        ind1 = sum(J(1:p-1)) + a(j);
        ind2 = size(DM,2)/K*m(j) - N2 + k;
        c(k,j) = DM(ind1,ind2);
        nrc(k) = nrc(k) + DM(ind1,ind2);
    end
end