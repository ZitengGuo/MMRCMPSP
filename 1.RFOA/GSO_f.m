%% Greedy Search Operator
%% =================================================================
function MM = GSO_f(I,J,K,N2,DM,NRC,UNRUC,P,A,M)
MM = M;
i = randperm(I,1);
s = 0;
for j = 1:i-1
    s = s + J(P(j));
end
p = P(i);
a = A(s+1:s+J(p));
m = M(s+1:s+J(p));
%% identify and select the bottleneck activity
[c,nrc] = NRRC_f1(p,a,m,N2,J,K,DM);
c_s = sum(c);
[~,ind] = sort(c_s);
%% calculate NRR consumption of selected activity in different modes
r_c = NRRC_f2(p,a,ind(end),N2,J,K,DM);
cost = r_c .* (UNRUC .* ones(K,N2));
n = nrc - NRC(p,:);
c_r = (c(:,ind(end)))' - n;
c_f = r_c - c_r .* ones(K,N2);
cost_s = inf * ones(1,K);
for k = 1:K
    if isempty(find(c_f(k,:)>0,1))
        cost_s(k) = sum(cost(k,:));
    end
end
[~,ind1] = min(cost_s);
MM(s+ind(end)) = ind1;