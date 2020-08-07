%% Fitness Function
%% FT   Finish Time
%% NRU  Non-Renewable Resource Utilization
%% FT,E,Td,TRR,RRU,RRI,B,PC,NRU,RUC,RIC,TC,
%% =================================================================
function Z = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,UNRUC,RD,DD,FP,UB,UP,PP,AA,MM)
len = size(DM,2)/K;
FT = zeros(1,I);
RC = zeros(N1,10000);
for i = 1:N1
    RC(i,:) = RRC(i) * ones(1,10000);
end
NRU = zeros(1,N2);
%% Finish time of projects 
for i = 1:I
    s = 0;
    for j = 1:i-1
        s = s + J(PP(j));
    end
    P = PP(i);
    A = AA(s+1:s+J(P));
    % successors for current activity sequence
    for j = 1:J(P)
        su{j} = Su{sum(J(1:P-1))+A(j)};
    end
    % finish time of each activity
    t = zeros(1,J(P));
    t0 = RD(P) + 1;
    for j = 1:J(P)
        M = MM(s+j);
        dm = DM(sum(J(1:P-1))+A(j),len*(M-1)+1:len*(M-1)+len);
       %% Non-Renewable Resource Utilization
        for k = 1:N2
            NRU(k) = NRU(k) + dm(end+k-N2);
        end
       %% Find the longest finish time of precedences for A(j)
        if j > 1
            t0 = CalculateT_f(su,A(j),j,t);
        end
        [t(j),RC] = CalculateFT_f(N1,RC,t0,dm);
    end
    FT(i) = t(end) - 1;
end
FT = FT(PP);
%% Earliness:negetive->0
E = DD - FT;
E(E < 0) = 0;
%% Bonus
B = E * UB';
%% Tardiness:negetive->0
Td  = FT - DD;
Td(Td < 0) = 0;
%% Penalty Cost
PC = Td * UP';
%% Total Renewable Resource
TRR = RRC * max(FT);
%% Renewable Resource Idleness 
RRI = sum(RC(:,2:max(FT)+1),2);
RRI = RRI';
%% Renewable Resource Idleness Cost
RIC = RRI * URIC';
%% Renewable Resource Utilization
RRU = TRR - RRI;
%% Resource Utilization Cost
RUC = RRU * URUC' + NRU * UNRUC';
%% Total Cost
TC = RUC + RIC + PC;
%% Total Net Profit(Object)
Z = sum(FP) + B - TC;