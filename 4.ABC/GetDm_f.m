%% Get Data Matrix
%% =================================================================
function dm = GetDm_f(DM,K)
dm = [];
for i = 1:K
    dm = [dm,DM(i:3:end,:)];
end