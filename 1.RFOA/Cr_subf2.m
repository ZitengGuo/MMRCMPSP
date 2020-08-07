%% Change Modes
%% =================================================================
function child_M = Cr_subf2(parent_A,parent_M,child_A,len)
child_M = parent_M;
for i = 1:len
    child_M(child_A==parent_A(i)) = parent_M(i);
end