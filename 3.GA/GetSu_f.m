%% Get Successors
%% =================================================================
function Su = GetSu_f(numdata)
[i1,i2] = size(numdata);
for i = 1:i1
    a = zeros(1,i2);
    for j = 1:i2
        a(j) = numdata(i,j);
    end
    a(isnan(a)) = [];
    Su{i} = a;
end