function [TOF] = tof_calculator (t_dep_vect,t_arr_vect)

%% This function evaluates a vector of all "Time of flight"
% for each date of departure and arrival
%
% Input:
% t_dep_vect       - vector of departure's dates
% t_arr_vect       - vector of arrival's dates
%
% Output:
% TOF              - vector of all times of flight


%% Preallocation 
l1 = length(t_dep_vect);
l2 = length(t_arr_vect);

TOF = zeros(l1,l2);

%% Implementation of a for cycle to obtain the TOF vector

for i = 1 : l1
    TOF(i,:) = t_arr_vect - t_dep_vect(i);
end

end