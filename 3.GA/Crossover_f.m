%% Crossover Operator
%% =================================================================
function [A1,A2,M1,M2] = Crossover_f(I,J,P1,P2,A1,A2,M1,M2)
ii = randperm(I,1);
s = zeros(1,I);
for i = 1:I
    for j = 1:i-1
        s(i) = s(i) + J(P1(j));
    end
end
s1 = s(P1==ii);
s2 = s(P2==ii);
len = J(P1(ii));
%% Parents and Offsprings
% parent00 and parent01 in group 0 to breed the offspring0
father1_A = A1(s1+1:s1+len);
mother1_A = A2(s2+1:s2+len);
% parent10 and parent11 in group 1 to breed the offspring1
father2_A = mother1_A;
mother2_A = father1_A;
% two offsprings in ROA
child0_A = zeros(1,len);
child1_A = zeros(1,len);
%% Random Binary Sequence
bin_seq = round(rand(1,len));
%% Modified Precedence Preservative Crossover
for i = 1:len
    if bin_seq(i)
        [child0_A(i),mother1_A,father1_A] = Cr_subf(mother1_A,father1_A);
        [child1_A(i),mother2_A,father2_A] = Cr_subf(mother2_A,father2_A);
    else
        [child0_A(i),father1_A,mother1_A] = Cr_subf(father1_A,mother1_A);
        [child1_A(i),father2_A,mother2_A] = Cr_subf(father2_A,mother2_A);
    end
end
%% Offspring1 and Offspring2
A1(s1+1:s1+len) = child0_A;
A2(s2+1:s2+len) = child1_A;