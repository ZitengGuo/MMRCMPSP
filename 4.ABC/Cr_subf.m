function [child_A,father_A,mother_A] = Cr_subf(father_A,mother_A)
child_A = father_A(1);
mother_A(mother_A==father_A(1)) = [];
father_A = father_A(2:end);