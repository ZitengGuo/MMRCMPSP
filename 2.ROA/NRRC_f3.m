%% Update modes, n and ind
%% =================================================================
function [m,n,nrc,ind] = NRRC_f3(mn,m,ind,n,nrc,r_c,N2)
mn = mn(1);  % the new mode
mo =  m(ind);  % the old mode
m(ind) = mn;
for j = 1:N2
    n(j) = n(j) + r_c(mn,j) - r_c(mo,j);
    nrc(j) = nrc(j) + r_c(mn,j) - r_c(mo,j);
end
ind = find(n>0);