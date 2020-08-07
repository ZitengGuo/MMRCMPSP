%% Get the best mode sequence
% mode: all modes which are ranked
% mode_g: the best mode sequence
% nrc: non-renewable resource consumption corresponding to nrc_g
% nrc_g: non-renewable resource consumption corresponding to mode_g
% nrc_s: the sum consumption of two types of non-renewable resource for mode_g
% total_c: total non-renewable resource consumption for different non-renewable resource of each project 
%% =================================================================
function mode_g = GetMgb_f(I,J,K,N2,NRC,data)
J = J(1);
%% Firstly, selecte mode which minimize the value of pt*rrc+nrc
nrc = data(:,end-1:end);
% process time
PT = data(:,end-4);
% sum consumption of renewable resources
RRS = sum(data(:,end-3:end-2),2);
% sum consumption of non-renewable resources
NRS = sum(data(:,end-1:end),2);
% pt*sum_rrc+sum_nrc -> rank for each activity
mode = PT .* RRS + NRS;
% initialize mode_g and nrc_g
len = length(PT);
mode_g = zeros(len/K,1);
nrc_g = zeros(len/K,2);
for i = 1:K:len
    [~,ind] = sort(mode(i:i+K-1));
    % choose the best mode for each activity
    mode_g((i+K-1)/K) = ind(1);
    mode(i:i+K-1) = ind;
    % record the NRC correspond to the gbest mode
    tmp = nrc(i:i+K-1,:);
    nrc(i:i+K-1,:) = tmp(ind,:);
    nrc_g((i+K-1)/K,:) = nrc(i,:);
end
% calculate the total consumption of each NR for each activity 
total_c = zeros(I,N2);
for i = 1:I
    total_c(i,:) = sum(nrc_g(J*(i-1)+1:J*i,:));
end
%% Secondly, repair the mode which violates the non-renewable resource constriant
diff = total_c - NRC;
for i = 1:I
    if any(diff(i,:)>0)
        % copy nrc sequence of ith project
        nrc_g_i = nrc_g(J*(i-1)+1:J*i,:);
        nrc_s_i = sum(nrc_g_i,2);
        [~,ind] = sort(nrc_s_i,'descend');
        ii = 1;
        while any(diff(i,:)>0)
            % get nrc of K modes for selected activity
            i1 = (i-1) * J * K + (ind(ii)-1) * K;
            nrc_i = nrc(i1+1:i1+K,:);
            % for both resource violation
            if all(diff(i,:)>0)
                nrc_i_s = sum(nrc_i,2);
                % mode whose nrc less than current mode
                i2 = find(nrc_i_s<nrc_s_i(ind(ii)),1);
            % for one resource violation
            else
                % resource which violates constraint
                nrc_vio = nrc_i(:,diff(i,:)>0);
                i2 = find(nrc_vio<nrc_g_i(ind(ii),diff(i,:)>0),1);
            end
            if ~isempty(i2)
                mode_g(J*(i-1)+ind(ii)) = mode(i1+i2);
                change = nrc_g_i(ind(ii),:) - nrc_i(i2,:);
                diff(i,:) = diff(i,:) - change;
                nrc_g_i(ind(ii),:) = nrc_i(i2,:);
            end
            ii = ii + 1;
            % if it's not feasible after a pass, then restart a new pass.
            if ii > J
                ii = 1;
                nrc_s_i = sum(nrc_g_i,2);
                [~,ind] = sort(nrc_s_i,'descend');
            end
        end
    end
end