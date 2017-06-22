function [TOF] = tof_calculator (t_dep_vect,t_arr_vect)

% tof_calculator.m
% 
% PROTOTYPE:
%   [rx_vect, ry_vect, rz_vect, vx_vect, vy_vect, vz_vect] = intARC_lamb(r_1,VI,mu,time,n)
%
% DESCRIPTION:
% 	This function implements the integration of the dynamics orbit equations
%
% INPUT:
%   t_dep_vect[]       Vector of departure's dates
%   t_arr_vect[]       Vector of arrival's dates
%
% OUTPUT :
%   TOF[]              Vector of all times of flight
%
% AUTHOR:
%   Alfonso Collogrosso
%

% Preallocation 
l1 = length(t_dep_vect);
l2 = length(t_arr_vect);

TOF = zeros(l1,l2);

% For cycle to obtain the TOF vector
for i = 1 : l1
    TOF(i,:) = t_arr_vect - t_dep_vect(i);
end

end