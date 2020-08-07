%% Feasibility Check & Repair
%% for Successor Constraints and Non-Renewable Resource Constraints
%% Part1: Successor Constraints Check & Repair
%% Su: Successor Acitivities & Input
%% P,A,M: Candidate Solution & One-Dimension Vector
%% =================================================================
function [FC_S,A_N] = Successor_f(I,J,Su,P,A)
%function [FC_S] = Successor_f(I,J,Su,P,A)
A_N = A;
FC_S = zeros(1,I);   % 0-1 decision variable(Precedence Constraints)
s = zeros(1,I);
su = {};    % to save successor of activieties
%% Check Precedence Constraints
for i = 1:I
    % Find the start index of Activity
    for j = 1:i-1
        p = P(j);
        s(i) = s(i) + J(p);
    end
    a = A(s(i)+1:s(i)+J(P(i)));     % Activities of Project(i)
    p = P(i);
    len1 = length(a);
    c = {};
    for j = 1:len1
        b = Su{sum(J(1:p-1))+a(j)};         % Successor Activities of Activity(j)
        c{j} = intersect(a(1:j),b);       % Intersection(½»¼¯)
        if ~isempty(c{j})  
            FC_S(i) = 1;
            %break;
        end
    end
    su{i} = c;  % e.g. {{...},{...},...,{...}}
end
%% Repair
pp = [];
for i = 1:I
    len2 = J(P(i));
    %% only repair infeasible projects
    if FC_S(i) == 1
        pp = A(s(i)+1:s(i)+len2);
        su_i = su{i};
        ll = zeros(1,len2);
        for j = 1:len2
           ll(j) = length(su_i{j});
        end
        index = find(ll>0);
        index1 = index(1);          % select the first index
        ch1 = pp(index1);            % the first activity which will be moved
        pp(index1) = [];
        index = [];
        for k = 1:length(su_i{index1})
            index = [index find(pp == su_i{index1}(k))];
        end
        index2 = min(index);
        pp = [pp(1:index2-1) ch1 pp(index2:end)];
        A_N(s(i)+1:s(i)+len2) = pp;
    end
end