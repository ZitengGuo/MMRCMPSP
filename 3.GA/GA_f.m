function [Gbest_P,Gbest_A,Gbest_M,gbest,gb,I_time] = GA_f(I,J,K,N,N1,N2,Su,DM,RRC,NRC,URUC,URIC,UNRUC,RD,DD,FP,UB,UP,NI,Pm,BP)
%%------------------------------------------------------------------------------------------
%% Parameter Definition
%% I        Number of Projects
%% J        Number of Activities
%% K        Number of Modes
%% N        Number of Population
%% N1       Number of Renewable Resource
%% N2       Number of Non-Renewable Resource
%% Su       Successor
%% DM       Data Matrix of projects, process time...
%% RRC      Renewable Resource Capacity
%% NRC      Non-renewable Resource Capacity
%% URUC     Unit Renewable Resource Utilization Cost
%% URIC     Unit Renewable Resource Idleness Cost
%% UNRUC    Unit Non-Renewable Resource Utilization Cost
%% RD       Release Date
%% DD       Due Date
%% FP       Fixed Profit
%% UB       Unit Bonus
%% UP       Unit Penalty
%% NI       Number of Iterations
%%------------------------------------------------------------------------------------------
%% ==================Import the Initial Populations=================
%% ==================Import the Initial Populations=================
    if BP==1
        filename = '..\..\Initial Populations\Initial_Populations_A1';
    elseif BP==2
        filename = '..\..\Initial Populations\Initial_Populations_A2';
    elseif BP==3
        filename = '..\..\Initial Populations\Initial_Populations_A3';
    elseif BP==4
        filename = '..\..\Initial Populations\Initial_Populations_A4';
    elseif BP==5
        filename = '..\..\Initial Populations\Initial_Populations_A5';
    elseif BP==6
        filename = '..\..\Initial Populations\Initial_Populations_A6';
    elseif BP==7
        filename = '..\..\Initial Populations\Initial_Populations_A7';
    elseif BP==8
        filename = '..\..\Initial Populations\Initial_Populations_A8';
    elseif BP==9
        filename = '..\..\Initial Populations\Initial_Populations_A9';
    elseif BP==10
        filename = '..\..\Initial Populations\Initial_Populations_A10';
    elseif BP==11
        filename = '..\..\Initial Populations\Initial_Populations_Case';
    end
Sheet1 = 'Project';
Sheet2 = 'Activity';
Sheet3 = 'Mode';
Sheet4 = 'Fitness';
[P,~] = xlsread(filename,Sheet1);
[A,~] = xlsread(filename,Sheet2);
[M,~] = xlsread(filename,Sheet3);
[Z,~] = xlsread(filename,Sheet4);
[gbest,ind]= max(Z);
Gbest_P = P(ind,:);
Gbest_A = A(ind,:);
Gbest_M = M(ind,:);
gb = [];
I_time = [];
ni = 1;
%% ===========================Main Loop=============================
tic;
while toc < NI
I_time(ni) = toc;
    %% =====================Selection Operator======================
    [P,A,M] = Roulette_f(P,A,M,Z,N);
    %% ======================Mutation Operator======================
    for i = 1:Pm*N
        [P(i,:),A(i,:),M(i,:)] = Mutation_f(I,J,P(i,:),A(i,:),M(i,:));
    end
    %% ======================Crossove Operator======================
    for i = Pm*N+1:2:(N-1)
        [A(i,:),A(i+1,:)] = Crossover_f(I,J,P(i,:),P(i+1,:),A(i,:),A(i+1,:));
        M(i,:) = NRRC_f(I,J,K,N2,DM,NRC,P(i,:),A(i,:),M(i,:));
        M(i+1,:) = NRRC_f(I,J,K,N2,DM,NRC,P(i+1,:),A(i+1,:),M(i+1,:));
    end
    %% =====================Fitness Calculation=====================
    for i = 1:N
        Z(i) = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,UNRUC,RD,DD,...
                         FP,UB,UP,P(i,:),A(i,:),M(i,:));
    end 
    % update the global best solution
    [pbest,ind]= max(Z);
    if pbest > gbest
        Gbest_P = P(ind,:);
        Gbest_A = A(ind,:);
        Gbest_M = M(ind,:);
        gbest = pbest;
    end
    gb = [gb,gbest];
    P(1,:) = Gbest_P;
    A(1,:) = Gbest_A;
    M(1,:) = Gbest_M;
    ni = ni + 1;
%% Moving graph plot
plot(I_time,gb);drawnow
end