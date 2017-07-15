function [DV_MIN, Dv_min_TOF_1, Dv_min_TOF_2, r1_arc, r2_arc, r3_arc, v_saturn, t_saturn, dv_ga] = Fmincon_Flyby(t_dep)

% Fmincon_Flyby.m
%
% PROTOTYPE:
%   [DV_MIN, Dv_min_TOF_1, Dv_min_TOF_2, r1_arc, r2_arc, r3_arc, v_saturn, t_saturn, dv_ga] = Fmincon_Flyby(t_dep)
%
% DESCRIPTION:
% 	This function set the costraint, the upper and the lower bound to call
% 	the optimizator fmincon that evaluates the fitness function
% 	dv_optimizer. Then call the fitness function itself and collects
%   the best results.
%
% INPUT:
%   t_dep[]             Vector of departure\arrival dates (needed to
%                       evaluate initial condition)
%
% OUTPUT :
%   DV_MIN[1]           Minimum DV found by the optimizer
%   Dv_min_TOF_1[1]     TOF corresponding to the first transfer arc
%   Dv_min_TOF_2[1]     TOF corresponding to the second transfer arc
%   r1_arc[3]           Position of Mars for the transfer arc Mars->Saturn
%   r2_arc[3]           Position of Mars for the transfer arc Mars->Saturn and Saturn->Neptune
%   r3_arc[3]           Position of Mars for the transfer arc Saturn->Neptune
%   v_saturn[3]         Saturn velocity at flyby
%   t_saturn[1]         Saturn day at flyby
%   dv_ga[1]            DV to be given by propulsive system for the flyby
%
% AUTHOR:
%   Alfonso Collogrosso, Francescodario Cuzzocrea, Benedetto Lui
%

% Initial condition (putted here manually, guessed from the iterative cycle
% to make the fmicon algorithm converge faster, can be automated)
x0 = [t_dep(1);t_dep(11);t_dep(71)];

% Costrained system of equation for TOFs (we cannot arrive before we
% depart)
% Ax <= b :
%             x(1)-x(2)+0=0
%             0+x(2)-x(1)=0
A = [1, -1, 0; 0 , 1, -1];
b = [0; 0];

% Upper bound and lower bound are first day and latest day of the given
% window for the mission
LB = 5844*[1 1.1 1.2];
UB = 20044*[1 1 1];

% Options to remove output
options = optimoptions('fmincon','Display','off');

% Call the optimizator to find best days
x = fmincon(@dv_optimizator,x0,A,b,[],[],LB,UB,[],options);

% Outputs DV_min and the position of the planets evaluated at the days
% founded by the fmincon optimizator
[DV_MIN, r1_arc, r2_arc, r3_arc, v_saturn, dv_ga] = dv_optimizator(x);

% Evaluate the transfer times for Mars -> Saturn and Saturn -> Neptune
Dv_min_TOF_1 = (x(2)-x(1))*86400;
Dv_min_TOF_2 = (x(3)-x(2))*86400;

% Day for the best flyby (relative to saturn)
t_saturn = x(2);

end