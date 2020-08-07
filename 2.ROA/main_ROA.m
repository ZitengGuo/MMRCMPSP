clear,clc
%% ======================Initialize Parameters======================
NI = 1000;
run= 1;
%% Benchmark parameters
BP = 11;
T_BP = 11;
%% Fixed
N_r = 240;
N_v = 60;
MF = 150;
Pm = 0.2;
%% =====================Benchmark problems==========================
BP_run_gb = [];
while  BP <= T_BP
    if BP==1
        filename = '..\..\Benchmark Problem\A1';
    elseif BP==2
        filename = '..\..\Benchmark Problem\A2';
    elseif BP==3
        filename = '..\..\Benchmark Problem\A3';
    elseif BP==4
        filename = '..\..\Benchmark Problem\A4';
    elseif BP==5
        filename = '..\..\Benchmark Problem\A5';
    elseif BP==6
        filename = '..\..\Benchmark Problem\A6';
    elseif BP==7
        filename = '..\..\Benchmark Problem\A7';
    elseif BP==8
        filename = '..\..\Benchmark Problem\A8';
    elseif BP==9
        filename = '..\..\Benchmark Problem\A9';
    elseif BP==10
        filename = '..\..\Benchmark Problem\A10';
        elseif BP==11
        filename = '..\..\Benchmark Problem\Case';
    end
    %% ==================== Read inputs================================
    Sheet1 = 'Main';
    Sheet2 = 'Successors';
    Sheet3 = 'DM';
    [numdata1,~] = xlsread(filename,Sheet1);
    [numdata2,~] = xlsread(filename,Sheet2);
    [numdata3,~] = xlsread(filename,Sheet3);
    I = numdata1(1,1);
    J = numdata1(2,1)*ones(1,I);
    K = numdata1(3,1);
    N1 = numdata1(4,1);
    N2 = numdata1(5,1);
    Su = GetSu_f(numdata2(:,3:end));
    DM = numdata3(:,4:end);
    DM = GetDm_f(DM,K);
    RRC = numdata1(6,1:N1);
    NRC = numdata1(7,1:N2*I);
    NRC = reshape(NRC,[N2,I])';
    URUC = numdata1(8,1:N1);
    URIC = 0.25*URUC;
    UNRUC = numdata1(9,1:N2);
    RD = numdata1(10,1:I);
    CP = numdata1(11,1:I);
    if BP==11
        DD = RD + 1 * CP;
    else
        DD = RD + 7 * CP;
    end
    FP = CalculateFP_f(I,J,K,DM,URUC,UNRUC);
    UB = ceil(FP/100);
    UP = ceil(FP/50);
    %% Benchmark problems
    if BP==11
        fprintf("Case Problem:")
    else
        fprintf("Benchmark problems: A"),disp(BP)
    end
    run_P = [];
    run_A = [];
    run_M = [];
    run_gbest = [];
    %% ============================Run ROA_f===========================
    % Multiple Runs
    for i=1:run
        [P,A,M,gbest,gb,Itr_time] = ROA_f(I,J,K,N1,N2,Su,DM,RRC,NRC,URUC,URIC,UNRUC,RD,...
            DD,FP,UB,UP,NI,N_r,N_v,MF,Pm,BP);
        %%
            run_gb{i,:} = gb;
            run_Itr_time{i,:} = Itr_time;
            run_gbest(i,:) = gb(end);
            run_P(i,:) = P;
            run_A(i,:) = A;
            run_M(i,: )= M;
            fprintf("Gbest:"),disp(run_gbest)
    end
    %%
    BP_run_gb{BP} = run_gb;
    BP_run_Itr_time{BP} = run_Itr_time;
    BP_run_gbest{BP} = run_gbest;
    BP_run_P{BP} = run_P;
    BP_run_A{BP} = run_A;
    BP_run_M{BP} = run_M;
    BP = BP+1;
end
fprintf("Program END:")