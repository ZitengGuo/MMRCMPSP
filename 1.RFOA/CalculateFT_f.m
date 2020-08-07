%% Calculate Finish Time
%% =================================================================
function [t,RC] = CalculateFT_f(N1,RC,t,dm)
% start time of current Project
t1 = t + dm(1);
% logical array(0-1 element) for "or" judgement
logic = zeros(1,N1);
for k = 1:N1
    logic(k) = dm(k+1) > min(RC(k,t:t1));
end
while sum(logic) > 0
    t = t + 1;
    t1 = t + dm(1) - 1;
    for k = 1:N1
        logic(k) = dm(k+1) > min(RC(k,t:t1));
    end
end
for k = 1:N1
    RC(k,t:t1) = RC(k,t:t1) - dm(k+1);
end
t = t1;