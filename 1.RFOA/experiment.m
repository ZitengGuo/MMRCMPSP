%% Experiments
Exp_n = 1;
T_exp_n = 9;
%% ===================== Experiments Loops=======================
 while Exp_n <= T_exp_n
        if Exp_n == 1
            NK = 3;
            N_r = 80;
            N_v = 20;
            MF = 50;
            Pm = 0.1;
            Pg = 0.2;
        elseif Exp_n == 2
            NK = 3;
            N_r = 80;
            N_v = 20;
            MF = 100;
            Pm = 0.2;
            Pg = 0.4;
        elseif Exp_n == 3
            NK = 3;
            N_r = 80;
            N_v = 20;
            MF = 150;
            Pm = 0.3;
            Pg = 0.6;
        elseif Exp_n == 4
            NK = 5;
            N_r = 48;
            N_v = 12;
            MF = 50;
            Pm = 0.2;
            Pg = 0.6;
        elseif Exp_n == 5
            NK = 5;
            N_r = 48;
            N_v = 12;
            MF = 100;
            Pm = 0.3;
            Pg = 0.2;
        elseif Exp_n == 6
            NK = 5;
            N_r = 48;
            N_v = 12;
            MF = 150;
            Pm = 0.1;
            Pg = 0.4;
        elseif Exp_n == 7
            NK = 10;
            N_r = 24;
            N_v = 6;
            MF = 50;
            Pm = 0.3;
            Pg = 0.4;
        elseif Exp_n == 8
            NK = 10;
            N_r = 24;
            N_v = 6;
            MF = 100;
            Pm = 0.1;
            Pg = 0.6;
        elseif Exp_n == 9
            NK = 10;
            N_r = 24;
            N_v = 6;
            MF = 150;
            Pm = 0.2;
            Pg = 0.2;
        elseif Exp_n == 10
            NK = 3;
            N_r = 80;
            N_v = 20;
            MF = 150;
            Pm = 0.2;
            Pg = 0.4;
        end
        Exp_run_gb{Exp_n}=run_gb;
        Exp_run_Itr_time{Exp_n}=run_Itr_time;
        Exp_run_gbest{Exp_n}=run_gbest;
        Exp_run_P{Exp_n}=run_P;
        Exp_run_A{Exp_n}=run_A;
        Exp_run_M{Exp_n}=run_M;
        Exp_n = 1+ Exp_n;
    end