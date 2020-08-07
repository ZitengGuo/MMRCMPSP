%% determine whether a cell is empty
%% =================================================================
function c = CellIsempty_f(A)
m = size(A,2);
count = zeros(1,m);
for i = 1:m
    count(i) = count(i) + ~isempty(A{i});
end
c = find(count > 0);