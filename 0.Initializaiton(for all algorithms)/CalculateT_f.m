%% Calculate the longest finish time of precedences for A(j)
%% =================================================================
function temp = CalculateT_f(su,a,j,t)
temp = 0;
for i = j-1:-1:1
    if ~isempty(find(su{i}==a,1))
        tt = t(i)+1;
        if tt > temp
            temp = tt;
        end
    end
end