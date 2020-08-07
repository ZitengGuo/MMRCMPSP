%% Part2: Non-Renewable Resource Constraints Check & Repair
%% r_s:  the sum of NRR consumption for each activity
%% r_c:  NRR consumption of the current activity for different modes
%% r_cs: the total NRR consumption  for different modes
%% c_r:  the rest consumption of NRR for current activity
%% =================================================================
function M_N = NRRC_f(I,J,K,N2,DM,NRC,P,A,M)
M_N = M;
for i = 1:I
    s = 0;
    for j = 1:i-1
        s = s + J(P(j));
    end
    p = P(i);
    a = A(s+1:s+J(p));
    m = M(s+1:s+J(p));
    [c,nrc] = NRRC_f1(p,a,m,N2,J,K,DM);
    n = nrc - NRC(p,:);
    ind = find(n>0);
    %% Check & Repair
    if ~isempty(ind)
        % rank the total NRR consumption which is sum of NRRC1 and NRRC2
        r_s = sum(c);
        [~,ind1] = sort(r_s);
        num = 0;
        while ~isempty(ind) && num<J(p)
            r_c = NRRC_f2(p,a,ind1(end-num),N2,J,K,DM);
            len = length(ind);
            if len == 2
                r_cs = sum(r_c,2);
                mn = find(r_cs==min(r_cs));
            else
                ind2 = find(n<=0);
                c_r = NRC(p,ind2) - nrc(ind2) + c(ind2,ind1(end-num));
                tmp = r_c(:,ind2) > c_r;
                r_c(tmp,3-ind2) = inf;
                r_m = min(r_c(:,3-ind2));
                mn = find(r_c(:,3-ind2) == r_m);
                r_m = r_c(mn,ind2);
                mn = mn(r_m == min(r_m));
            end
            [m,n,nrc,ind] = NRRC_f3(mn,m,ind1(end-num),n,nrc,r_c,N2);
            num = num + 1;
        end
        if num > J(p)-1
            [c,~] = NRRC_f1(p,a,m,N2,J,K,DM);
            c_tmp = c';
            while ~isempty(ind)
                [~,ii1] = max(n);
                [~,ii2] = max(c_tmp(:,ii1));
                r_c = NRRC_f2(p,a,ii2,N2,J,K,DM);
                r_cs = sum(r_c,2);
                mn = find(r_cs==min(r_cs));
                [m,n,nrc,ind] = NRRC_f3(mn,m,ii2,n,nrc,r_c,N2);
                c_tmp(ii2,:) = -inf;
            end
        end
        M_N(s+1:s+J(p))= m;
    end
end