function [Dv, r_mars, r_saturn, r_neptune, v_saturn, dv_ga] = dv_optimizator(x)

% dv_optimizator.m
% 
% PROTOTYPE:
%   [Dv, r_mars, r_saturn, r_neptune, v_saturn, dv_ga] = dv_optimizator(x)
%
% DESCRIPTION:
% 	This function  is a fitness function that can be indifferently called
%   from (hopefully) any MATLAB optimization algorithm.
%   It evaluates the DV needed for a flyby from mars to neptune around
%   saturn.
%
% INPUT:
%   x[3]                Vector of days
%
% OUTPUT :
%   Dv[1]               Dv for the overall transfer
%   r1_mars[3]          Position of Mars for the transfer arc Mars->Saturn
%   r2_saturn[3]        Position of Saturn to compute the transfer arc Mars->Saturn and Saturn->Neptune
%   r3_neptune[3]       Position of Neptune to compute the transfer arc Saturn->Neptune
%   v_saturn[3]         Saturn velocity at flyby
%   dv_ga[1]            DV to be given by propulsive system for the flyby
%
% AUTHOR:
%   Alfonso Collogrosso, Francescodario Cuzzocrea, Benedetto Lui
%

% Integer number identifying Mars, Saturn and Neptune for uplanet
ibody_mars = 4;
ibody_saturn = 6;
ibody_neptune = 8;

% From ephemeris compute position and velocity for the selected day
[kep_dep_vect_mars,ksun] = uplanet(x(1),ibody_mars);
[r_mars,v_mars] = kep2car(kep_dep_vect_mars,ksun);

[kep_dep_vect_saturn,~] = uplanet(x(2),ibody_saturn);
[r_saturn,v_saturn] = kep2car(kep_dep_vect_saturn,ksun);

[kep_dep_vect_neptune,~] = uplanet(x(3),ibody_neptune);
[r_neptune,v_neptune] = kep2car(kep_dep_vect_neptune,ksun);

% TOF to go from Mars to Saturn, in days
tof_1 = (x(2)-x(1))*86400;

% Compute the Lambert arc for tof_1
[~,~,~,~,VI_mars,VF_saturn,~,~] = lambertMR(r_mars,r_saturn,tof_1,ksun);
dv1_mars = norm(VI_mars - v_mars');
dv2_saturn = norm(v_saturn' - VF_saturn);
% Dv_matrix_1(i,j) = abs(dv1_mars) + abs(dv2_saturn);
% v_inf_matrix_1(i,j) = dv1_mars;

% TOF to go from Saturn to Neptune, in days
tof_2 = (x(3)-x(2))*86400;

% Compute the Lambert arc for tof_2
[~,~,~,~,VI_saturn,VF_neptune,~,~] = lambertMR(r_saturn,r_neptune,tof_2,ksun);
dv1_saturn = norm(VI_saturn - v_saturn');
dv2_neptune = norm(v_neptune' - VF_neptune);

% "Powered" DV
dv_ga = abs(dv1_saturn - dv2_saturn);

% Compute the total DV
Dv = dv1_mars + dv_ga + dv2_neptune;

end