%% Assign best mode sequence
function M = AssignMode_f(I,J,P,A,M_gb)
M = A;
for i = 1:I
    p = P(i);
    a = A((i-1)*J+1:i*J);
    m = M_gb((p-1)*J+1:p*J);
    M((i-1)*J+1:i*J) = m(a);
end