function [Gbest_P,Gbest_A,Gbest_M,gbest,gb,I_time] = RFOA_f(I,J,K,N1,N2,Su,DM,RRC,NRC,URUC,URIC,UNRUC,RD,DD,FP,UB,UP,NI,NK,N_r,N_v,MF,Pm,Pg,M_gb,BP)
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
%% NI       Ti of Iterations
%% NK       Number of Kits
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
%% =============Assign initial RZP, VZP and global best=============
% Global Best
Gbest_P = P(end,:);
Gbest_A = A(end,:);
Gbest_M = M(end,:);
gbest = Z(end);
% Current Location
Loc_P = cell(1,NK);
Loc_A = cell(1,NK);
Loc_M = cell(1,NK);
Loc_F = zeros(1,NK);
% Reachable Zone Population
RZP_P = cell(1,NK);
RZP_A = cell(1,NK);
RZP_M = cell(1,NK);
R_Fit = cell(1,NK);
% Visible Zone Population
VZP_P = cell(1,NK);
VZP_A = cell(1,NK);
VZP_M = cell(1,NK);
V_Fit = cell(1,NK);
% global best fitness of each iteration
gb = [];
I_time = [];
ni = 1;
n_pres = zeros(1,NK);
num = N_r + N_v;
for i = 1:NK
    RZP_P{i} = P((i-1)*num+1:(i-1)*num+N_r,:);
    RZP_A{i} = A((i-1)*num+1:(i-1)*num+N_r,:);
    RZP_M{i} = M((i-1)*num+1:(i-1)*num+N_r,:);
    R_Fit{i} = Z((i-1)*num+1:(i-1)*num+N_r);
    Loc_P{i} = P((i-1)*num+N_r,:);
    Loc_A{i} = A((i-1)*num+N_r,:);
    Loc_M{i} = M((i-1)*num+N_r,:);
    Loc_F(i) = Z((i-1)*num+N_r);
    VZP_P{i} = P(i*num-N_v+1:i*num,:);
    VZP_A{i} = A(i*num-N_v+1:i*num,:);
    VZP_M{i} = M(i*num-N_v+1:i*num,:);
    V_Fit{i} = Z(i*num-N_v+1:i*num);
end
%% ===========================Main Loop=============================
tic;
while toc <= NI
%     fprintf("iteration:"),disp(ni)
%     fprintf("gbest:"),disp(gbest)
    I_time(ni) = toc;
        %% ==================Local Optimization Phase===================
    for i = 1:NK
        %% select the best location from RZP
        r_p = RZP_P{i};
        r_a = RZP_A{i};
        r_m = RZP_M{i};
        r_f = R_Fit{i};
        r_best = max(r_f);
        r_loc = find(r_f == r_best);
        r_loc = r_loc(1);
        %% select the best location from VZP
        v_p = VZP_P{i};
        v_a = VZP_A{i};
        v_m = VZP_M{i};
        v_f = V_Fit{i};
        v_best = max(v_f);
        v_loc = find(v_f == v_best);
        v_loc = v_loc(1);
        %% calculate n_pres and relocate to the best location
        lrv_p = [Loc_P{i};r_p(r_loc,:);v_p(v_loc,:)];
        lrv_a = [Loc_A{i};r_a(r_loc,:);v_a(v_loc,:)];
        lrv_m = [Loc_M{i};r_m(r_loc,:);v_m(v_loc,:)];
        lrv_f = [Loc_F(i);r_best;v_best];
        [val,ind] = max(lrv_f);
        if Loc_F(i) == val
            n_pres(i) = n_pres(i) + 1;
        else
            Loc_P{i} = lrv_p(ind,:);
            Loc_A{i} = lrv_a(ind,:);
            Loc_M{i} = lrv_m(ind,:);
            Loc_F(i) = val;
            n_pres(i) = 0;
        end
    end
    %% ==================Global Optimization Phase==================
    %% relocate to the best value
    [val,ind] = max(Loc_F);
    gl_p = [Gbest_P;Loc_P{ind}];
    gl_a = [Gbest_A;Loc_A{ind}];
    gl_m = [Gbest_M;Loc_M{ind}];
    gl_f = [gbest;val];
    [val,ind] = max(gl_f);
    if gbest ~= val
        Gbest_P = gl_p(ind,:);
        Gbest_A = gl_a(ind,:);
        Gbest_M = gl_m(ind,:);
        gbest = val;
    end
    gb = [gb,gbest];
    %% Check the preservation
    for i = 1:NK
        if n_pres(i) == MF
          %% instruct raccoon to perform migration
           % generate Reachable Zone Population
            r_p = RZP_P{i};
            r_a = RZP_A{i};
            r_m = RZP_M{i};
            for j = 1:N_r
                % generate new population randomly
                [r_p(j,:),r_a(j,:),r_m(j,:)] = Random_f(I,J,K);
                % feasibility check & repair
                [r_a(j,:),r_m(j,:)] = SFCRP_f(I,J,K,N2,Su,DM,NRC,r_p(j,:),r_a(j,:),r_m(j,:));
            end
            RZP_P{i} = r_p;
            RZP_A{i} = r_a;
            RZP_M{i} = r_m;
            % generate Visible Zone Population
            v_p = VZP_P{i};
            v_a = VZP_A{i};
            v_m = VZP_M{i};
            for j = 1:N_v
                % generate new population randomly
                [v_p(j,:),v_a(j,:),v_m(j,:)] = Random_f(I,J,K);
                % feasibility check & repair
                [v_a(j,:),v_m(j,:)] = SFCRP_f(I,J,K,N2,Su,DM,NRC,v_p(j,:),v_a(j,:),v_m(j,:));
            end
            VZP_P{i} = v_p;
            VZP_A{i} = v_a;
            VZP_M{i} = v_m;
            % reset n_pres
            n_pres(i) = 0;
        else
           %% Mutation, Crossover and Greedy Search Operators
            % for Reachable Zone Population
            r_p = RZP_P{i};
            r_a = RZP_A{i}; 
            r_m = RZP_M{i};
            r_f = R_Fit{i};
            [r_p,r_a,r_m] = Operators_f(I,J,K,N2,N_r,DM,NRC,Pm,Pg,r_p,r_a,r_m,r_f,M_gb);
                                    
            RZP_P{i} = r_p;
            RZP_A{i} = r_a;
            RZP_M{i} = r_m;
            % for Visible Zone Population
            v_p = VZP_P{i};
            v_a = VZP_A{i};
            v_m = VZP_M{i};
            v_f = V_Fit{i};
            [v_p,v_a,v_m] = Operators_f(I,J,K,N2,N_v,DM,NRC,Pm,Pg,v_p,v_a,v_m,v_f,M_gb);
            VZP_P{i} = v_p;
            VZP_A{i} = v_a;
            VZP_M{i} = v_m;
        end
    end
    %% Evolution of fitness function for each food location
    for i = 1:NK
        % for Reachable Zone Population
        r_p = RZP_P{i};
        r_a = RZP_A{i};
        r_m = RZP_M{i};
        r_f = R_Fit{i};
        for j = 1:N_r
            r_f(j) = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,UNRUC,...
                               RD,DD,FP,UB,UP,r_p(j,:),r_a(j,:),r_m(j,:));
        end
        R_Fit{i} = r_f;
        % for Visible Zone Population
        v_p = VZP_P{i};
        v_a = VZP_A{i};
        v_m = VZP_M{i};
        v_f = V_Fit{i};
        for j = 1:N_v
            v_f(j) = Fitness_f(I,J,K,N1,N2,Su,DM,RRC,URUC,URIC,UNRUC,...
                               RD,DD,FP,UB,UP,v_p(j,:),v_a(j,:),v_m(j,:));
        end
        V_Fit{i} = v_f;
    end
    ni = ni + 1;
%% Moving graph plot
plot(I_time,gb);drawnow
end