%% Get the NRR consumptions of an activity in different modes
%% =================================================================
function r_c = NRRC_f2(p,a,ind,N2,J,K,DM)
i1 = sum(J(1:p-1)) + a(ind);
r_c = zeros(K,N2);
for k = 1:K
    for j = 1:N2
        i2 = size(DM,2)/K*k - N2 + j;
        r_c(k,j) = DM(i1,i2);
    end
end