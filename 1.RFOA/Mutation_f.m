%% Mutation Operator
%% =================================================================
function [PP,AA,MM] = Mutation_f(I,J,P,A,M)
PP = P;
AA = A;
MM = M;
s = zeros(1,I);
for i = 1:I
    for j = 1:i-1
        s(i) = s(i) + J(P(j));
    end
end
ind = randperm(I,2);
i1 = ind(1);
i2 = ind(2);
%% swap projects
tmp = PP(i1);
PP(i1) = PP(i2);
PP(i2) = tmp;
%% swap activities
tmp1 = AA(s(i1)+1:s(i1)+J(P(i1)));
AA(s(i1)+1:s(i1)+J(P(i1))) = AA(s(i2)+1:s(i2)+J(P(i2)));
AA(s(i2)+1:s(i2)+J(P(i2))) = tmp1;
%% swap modes
tmp2 = MM(s(i1)+1:s(i1)+J(P(i1)));
MM(s(i1)+1:s(i1)+J(P(i1))) = MM(s(i2)+1:s(i2)+J(P(i2)));
MM(s(i2)+1:s(i2)+J(P(i2))) = tmp2;