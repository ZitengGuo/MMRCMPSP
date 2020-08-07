%% determine whether new population is same as popolations
%% 0:same 1:different
%% =================================================================
function  a = SameP_f(P,A,M,Z,p,a,m,z)
ind = find(Z == z);
if ~isempty(ind)
    lg = zeros(1,3);
    for i = 1:length(ind)
        lg(1) = isequal(P(ind(i),:),p);
        lg(2) = isequal(A(ind(i),:),a);
        lg(3) = isequal(M(ind(i),:),m);
        if sum(lg) == 3
            a = 0;
            break;
        else
            a = 1;
        end
    end
else
    a = 1;
end