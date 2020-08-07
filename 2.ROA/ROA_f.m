function [Gbest_P,Gbest_A,Gbest_M,gbest,gb,I_time] = ROA_f(I,J,K,N1,N2,Su,DM,RRC,NRC,URUC,URIC,UNRUC,RD,DD,FP,UB,UP,NI,N_r,N_v,MF,Pm,BP)
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
%% N_r      Number of Reachable Zone Candidates
%% N_v      Number of Visible Zone Candidates
%% MF       Migration Factor
%%------------------------------------------------------------------------------------------

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
%% ==============Assign initial RZP, VZP, Loc and Gbest=============
% Global Best Location
Gbest_P = P(end,:);
Gbest_A = A(end,:);
Gbest_M = M(end,:);
gbest = Z(end);
% Initial Location
Loc_P = Gbest_P;
Loc_A = Gbest_A;
Loc_M = Gbest_M;
loc_f = gbest;
% Reachable Zone Population
RZP_P = P(1:N_r,:);
RZP_A = A(1:N_r,:);
RZP_M = M(1:N_r,:);
R_Fit = Z(1:N_r);
% Visible Zone Population
VZP_P = P(N_r+1:N_r+N_v,:);
VZP_A = A(N_r+1:N_r+N_v,:);
VZP_M = M(N_r+1:N_r+N_v,:);
V_Fit = Z(N_r+1:N_r+N_v);
% Global Best Fitness of Each Iteration
gb = [];
% Perseveration parameter
n_pres = 0;
% iteration counter
ni = 1;
%% ===========================Main Loop=============================
tic;
while toc <= NI
    I_time(ni) = toc;
    %% select the best location from RZP
    r_best = max(R_Fit);
    r_loc = find(R_Fit == r_best,1);
    %% select the best location from VZP
    v_best = max(V_Fit);
    v_loc = find(V_Fit == v_best,1);
    %% calculate n_pres and relocate to the best location
    lrv_P = [Loc_P;RZP_P(r_loc,:);VZP_P(v_loc,:)];
    lrv_A = [Loc_A;RZP_A(r_loc,:);VZP_A(v_loc,:)];
    lrv_M = [Loc_M;RZP_M(r_loc,:);VZP_M(v_loc,:)];
    lrv_f = [loc_f;r_best;v_best];
    [val,ind] = max(lrv_f);
    if gbest == val
        n_pres = n_pres + 1;
    else
        Loc_P = lrv_P(ind,:);
        Loc_A = lrv_A(ind,:);
        Loc_M = lrv_M(ind,:);
        loc_f = val;
        n_pres = 0;
    end
    %% save the global best value of the current iteration
    if gbest < loc_f
        gbest = loc_f;
        Gbest_P = Loc_P;
        Gbest_A = Loc_A;
        Gbest_M = Loc_M;
    end
    gb = [gb,gbest];
    %% Check the preservation
    if n_pres == MF
        %% instruct raccoon to perform migration
        % generate Reachable Zone Population
        for j = 1:N_r
            % generate new population randomly
            [RZP_P(j,:),RZP_A(j,:),RZP_M(j,:)] = Random_f(I,J,K);
            % feasibility check & repair
            [RZP_A(j,:),RZP_M(j,:)] = SFCRP_f(I,J,K,N2,Su,DM,NRC,RZP_P(j,:),...
                RZP_A(j,:),RZP_M(j,:));
        end
        % generate Visible Zone Population
        for j = 1:N_v
            % genevate new population vandomly
            [VZP_P(j,:),VZP_A(j,:),VZP_M(j,:)] = Random_f(I,J,K);
            % feasibility check & repair
            [VZP_A(j,:),VZP_M(j,:)] = SFCRP_f(I,J,K,N2,Su,DM,NRC,VZP_P(j,:),...
                VZP_A(j,:),VZP_M(j,:));
        end
        % reset n_pres
        n_pres = 0;
    else
        %% Mutation and Crossover
        % for Reachable Zone Population
        [RZP_P,RZP_A,RZP_M ]= Operators_f(I,J,K,N2,N_r,DM,NRC,Pm,...
            RZP_P,RZP_A,RZP_M,R_Fit);
        % for Visible Zone Population
        [VZP_P,VZP_A,VZP_M] = Operators_f(I,J,K,N2,N_v,DM,NRC,Pm,...
            VZP_P,VZP_A,VZP_M,V_Fit);
    end
    %% Evolution of fitness function for each food location
    % for Reachable Zone Population
    for j = 1:N_r
        R_Fit(j) = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,UNRUC,RD,...
            DD,FP,UB,UP,RZP_P(j,:),RZP_A(j,:),RZP_M(j,:));
    end
    % for Visible Zone Population
    for j = 1:N_v
        V_Fit(j) = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,UNRUC,RD,...
            DD,FP,UB,UP,VZP_P(j,:),VZP_A(j,:),VZP_M(j,:));
    end
    ni = ni + 1;
    %% Moving graph plot
    plot(I_time,gb);drawnow
end