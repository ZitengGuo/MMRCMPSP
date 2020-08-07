clear,clc
%% ======================Initialize Parameters======================
N = 320;
filename = 'case_problem';
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
DD = RD + 1 * CP;
FP = CalculateFP_f(I,J,K,DM,URUC,UNRUC);
UB = ceil(FP/100);
UP = ceil(FP/50);
%%
[P,A,M,Z] = Initialization_f(I,J,K,N,N1,N2,Su,DM,RRC,NRC,URUC,URIC,UNRUC,RD,DD,FP,UB,UP);
xlswrite('Initial_Populations_case_study.xlsx',P,'Project');
xlswrite('Initial_Populations_case_study.xlsx',A,'Activity');
xlswrite('Initial_Populations_case_study.xlsx',M,'Mode');
xlswrite('Initial_Populations_case_study.xlsx',Z,'Fitness');