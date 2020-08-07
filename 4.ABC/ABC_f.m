function [Gbest_P,Gbest_A,Gbest_M,gbest,gb,I_time] = ABC_f(I,J,K,N,N_b,N1,N2,Su,DM,RRC,NRC,URUC,URIC,UNRUC,RD,DD,FP,UB,UP,NI,MF,Pm,BP)
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
%%==================Import the Initial Populations=================
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
%% Global Best Solution Of Iteration 0
[gbest,ind]= max(Z);
Gbest_P = P(ind,:);
Gbest_A = A(ind,:);
Gbest_M = M(ind,:);
%% Assign Memory Space For Bees
Bee_P = cell(1,N_b);
Bee_A = cell(1,N_b);
Bee_M = cell(1,N_b);
Bee_Z = cell(1,N_b);
%% Local Best Solution For Each Bee
Pbest_P = P(1:N_b,:);
Pbest_A = A(1:N_b,:);
Pbest_M = M(1:N_b,:);
pbest = Z(1:N_b);
%% Assign Neighbor Food Sources For Each Employee Bee
N_s = N / N_b;  % number of nectar sources for each bee
for i = 1:N_b
    Bee_P{i} = P(N_s*(i-1)+1:N_s*i,:);
    Bee_A{i} = A(N_s*(i-1)+1:N_s*i,:);
    Bee_M{i} = M(N_s*(i-1)+1:N_s*i,:);
    Bee_Z{i} = Z(N_s*(i-1)+1:N_s*i);
    % pbest of nectar sources for each bee
    [pbest(i),ind]= max(Bee_Z{i});
    Pbest_P(i,:) = Bee_P{i}(ind,:);
    Pbest_A(i,:) = Bee_A{i}(ind,:);
    Pbest_M(i,:) = Bee_M{i}(ind,:);
end
%% Global Best Fitness Value Of Each Iteration
gb = [];
%% Iteration Counter
ni = 1;
%% Limit Number for Scout Bee Stage
n_lim = zeros(1,N_b);
%% ===========================Main Loop=============================
tic;
while toc <= NI
    I_time(ni) = toc;
    %% Scout Bee Stage
    % determine whether sent scout bee or not
    for i = 1:N_b
        if n_lim(i) == MF
            % randomly generate the food sources
            PP = Bee_P{i};
            AA = Bee_A{i};
            MM = Bee_M{i};
            for j = 1:N_s
                [PP(j,:),AA(j,:),MM(j,:)] = Random_f(I,J,K);
                [AA(j,:),MM(j,:)] = SFCRP_f(I,J,K,N2,Su,DM,NRC,PP(j,:),AA(j,:),MM(j,:));
            end
            Bee_P{i} = PP;
            Bee_A{i} = AA;
            Bee_M{i} = MM;
        end
    end
    %% Employee Bee Stage
    % compute nectar amount of each ingredientof each neighbor
    if ni > 1
        for i = 1:N_b
            PP = Bee_P{i};
            AA = Bee_A{i};
            MM = Bee_M{i};
            for j = 1:N_s
                Bee_Z{i}(j) = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,...
                    UNRUC,RD,DD,FP,UB,UP,PP(j,:),AA(j,:),MM(j,:));
            end
            % update pbest and n_lim
            [num,ind]= max(Bee_Z{i});
            if pbest(i) < num
                pbest(i) = num;
                Pbest_P(i,:) = Bee_P{i}(ind,:);
                Pbest_A(i,:) = Bee_A{i}(ind,:);
                Pbest_M(i,:) = Bee_M{i}(ind,:);
                n_lim(i) = 0;
            else
                Bee_P{i}(1,:) = Pbest_P(i,:);
                Bee_A{i}(1,:) = Pbest_A(i,:);
                Bee_M{i}(1,:) = Pbest_M(i,:);
                Bee_Z{i}(1) = pbest(i);
                n_lim(i) = n_lim(i) + 1;
            end
        end
    end
    %% Onlooker Bee Stage
    % store global best solution and update it
    [num,ind]= max(pbest);
    if gbest < num
        gbest = num;
        Gbest_P = P(ind,:);
        Gbest_A = A(ind,:);
        Gbest_M = M(ind,:);
    end
    gb = [gb,gbest];
    % select parents in food source and perform crossover and mutation
    for i = 1:N_b
        [Bee_P{i},Bee_A{i},Bee_M{i}] = Operators_f(I,J,K,N2,N_s,DM,NRC,...
            Pm,Bee_P{i},Bee_A{i},Bee_M{i},Bee_Z{i});
        % update pbest
        [pbest(i),ind]= max(Bee_Z{i});
        Pbest_P(i,:) = Bee_P{i}(ind,:);
        Pbest_A(i,:) = Bee_A{i}(ind,:);
        Pbest_M(i,:) = Bee_M{i}(ind,:);
    end
    ni = ni + 1;
    %% Moving graph plot
    plot(I_time,gb);drawnow
end