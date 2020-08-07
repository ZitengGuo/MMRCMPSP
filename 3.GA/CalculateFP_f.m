%% Calculate Fixed Profit
%% =================================================================
function FP = CalculateFP_f(I,J,K,DM,URUC,UNRUC)
len = size(DM,2);
len1 = len/K;
s = zeros(I,len);
uc = [URUC,UNRUC];
c = zeros(I,len);
for i = 1:I
    i1 = sum(J(1:i-1));
    len2 = J(i);
    for k = 1:K
        for j = 2:len1
            i2 = (k-1)*len1 + j;
            s(i,i2) = sum(DM(i1+1:i1+len2,i2));
            c(i,i2) = uc(j-1)*s(i,i2);
        end
    end
end
FP = 1.1*sum(c,2)/K;
FP = FP';