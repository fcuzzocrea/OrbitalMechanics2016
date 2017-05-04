function [DV_MIN, Dv_min_TOF_1, Dv_min_TOF_2, r1_arc, r2_arc, r3_arc, v_saturn, t_saturn] = Fmincon_Flyby (t_dep)

x0 = [t_dep(1);t_dep(22);t_dep(143)];
A = [1, -1, 0; 0 , 1, -1];
b = [0; 0];
LB = 5844*[1 1.1 1.2];   % Lower bound
UB = 20044*[1 1 1];  % Upper bound

x = fmincon(@dv_optimizator,x0,A,b,[],[],LB,UB);

[DV_MIN, r1_arc, r2_arc, r3_arc, v_saturn] = dv_optimizator(x);
Dv_min_TOF_1 = (x(2)-x(1))*86400;
Dv_min_TOF_2 = (x(3)-x(2))*86400;
t_saturn = x(2);

end