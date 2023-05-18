clear
clc, clc, clc, clc, clc
close all

e_1 = element(10000 * 10, 10000 * 1000, [0, 0]', [100, 0]', [1, 2]');
e_2 = element(10000 * 10, 10000 * 1000, [100, 0]', [200, -75]', [2, 3]');

%% Global Stiffness Matrix
S_J = zeros(length(restraint));
S_J(e_1.dof,e_1.dof) = S_J(e_1.dof, e_1.dof) + e_1.S_M;
S_J(e_2.dof, e_2.dof) = S_J(e_2.dof, e_2.dof) + e_2.S_M;

S = S_J(restraint~=1,restraint~=1);
S_DR = S_J(restraint~=1,restraint~=0);
S_RD = S_J(restraint~=0,restraint~=1);
S_RR = S_J(restraint~=0,restraint~=0);

A_MS1 = [0 12 200 0 12 -200]';
A_MS2 = [-6 8 250 -6 8 -250]';

restraint = [1 1 1 0 0 0 1 1 1]';
ADOF = sum((restraint~=1));

A_MS1_global = e_1.R' * A_MS1;
A_MS2_global = e_2.R' * A_MS2;

A_E1 = zeros(length(restraint), 1);
A_E2 = zeros(length(restraint), 1);

A_E1(3*e_1.nodes(1)-2:3*e_1.nodes(1)) = -A_MS1_global(1:3);
A_E1(3*e_1.nodes(2)-2:3*e_1.nodes(2)) = -A_MS1_global(4:6);
A_E2(3*e_2.nodes(1)-2:3*e_2.nodes(1)) = -A_MS2_global(1:3);
A_E2(3*e_2.nodes(2)-2:3*e_2.nodes(2)) = -A_MS2_global(4:6);

A_E = A_E1 + A_E2;

A = [0 0 0 0 -10 -1000 0 0 0]';

A_C = A + A_E;

A_C_ren = zeros(length(restraint), 1);
A_C_ren(1:ADOF) = A_C(restraint==0);
A_C_ren(ADOF+1:end) = A_C(restraint==1);

A_D = A_C_ren(1:ADOF);
A_RL = -A_C_ren(ADOF+1:end);

D_R = [0 0 0 0 0 0]';

D = inv(S) * (A_D - S_DR * D_R);

A_R = A_RL + S_RD*D + S_RR*D_R;

%% Check Structure Equilibrium
Fx = sum(A_R(1:3:end)) + sum(A(1:3:end)) + sum(A_E(1:3:end));
Fy = sum(A_R(2:3:end)) + sum(A(2:3:end)) + sum(A_E(2:3:end));

%% Deflection
D_J = zeros(length(restraint), 1);
D_J(restraint==0) = D;
D_J(restraint==1) = D_R;

%% Member End Actions
A_M1 = A_MS1 + e_1.R * e_1.S_M * [D_J(3*e_1.nodes(1)-2:3*e_1.nodes(1)); D_J(3*e_1.nodes(2)-2:3*e_1.nodes(2))];
A_M2 = A_MS2 + e_2.R * e_2.S_M * [D_J(3*e_2.nodes(1)-2:3*e_2.nodes(1)); D_J(3*e_2.nodes(2)-2:3*e_2.nodes(2))];

