function [Dv, r_mars, r_saturn, r_neptune, v_saturn, dv_ga] = dv_optimizator(x)

ibody_mars = 4;
ibody_saturn = 6;
ibody_neptune = 8;

[kep_dep_vect_mars,ksun] = uplanet(x(1),ibody_mars);
[r_mars,v_mars] = kep2car(kep_dep_vect_mars,ksun);

[kep_dep_vect_saturn,~] = uplanet(x(2),ibody_saturn);
[r_saturn,v_saturn] = kep2car(kep_dep_vect_saturn,ksun);

[kep_dep_vect_neptune,~] = uplanet(x(3),ibody_neptune);
[r_neptune,v_neptune] = kep2car(kep_dep_vect_neptune,ksun);

tof_1 = (x(2)-x(1))*86400;

[~,~,~,~,VI_mars,VF_saturn,~,~] = lambertMR(r_mars,r_saturn,tof_1,ksun);
dv1_mars = norm(VI_mars - v_mars');
dv2_saturn = norm(v_saturn' - VF_saturn);
% Dv_matrix_1(i,j) = abs(dv1_mars) + abs(dv2_saturn);
% v_inf_matrix_1(i,j) = dv1_mars;

tof_2 = (x(3)-x(2))*86400;
[~,~,~,~,VI_saturn,VF_neptune,~,~] = lambertMR(r_saturn,r_neptune,tof_2,ksun);
dv1_saturn = norm(VI_saturn - v_saturn');
dv2_neptune = norm(v_neptune' - VF_neptune);
dv_ga = abs(dv1_saturn - dv2_saturn);

Dv = dv1_mars + dv_ga + dv2_neptune;

end