function [DV_MIN, Dv_min_TOF_1, Dv_min_TOF_2, r1_arc, r2_arc, r3_arc, v_saturn, t_saturn, dv_ga] = Flyby_GA(ga_it)

% Flyby_GA.m
% 
% PROTOTYPE:
%   [DV_MIN, Dv_min_TOF_1, Dv_min_TOF_2, r1_arc, r2_arc, r3_arc, v_saturn, t_saturn, dv_ga] = Flyby_GA(ga_it)
%
% DESCRIPTION:
% 	This function set the costraint, the upper and the lower bound to call
% 	a genetic algorithm that evaluates the fitness function
% 	dv_optimizer. Then call the fitness function itself and collects 
%   the best results.
% 	
% INPUT:
%   ga_it[]             Number of iterations tbd with the ga optimizer
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

% Since the build of the population is very resource hungry (since we have
% to run the genetic algorithms several times to found the best minimum DV
% we put a flag : if 0 use the best result obtained until now, else iterate
% the ga optimizer ga_it times
if ga_it
    %Fitness function
    ObjectiveFunction = @dv_optimizator;
    
    % Number of variables : x(1) tof_1, x(2) tof_2, x(3) tof_3
    nvars = 3;
    
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
    
    % Preallocation
    vect_t(ga_it,3) = 0;
    vect_dv(ga_it) = 0;
    options = optimoptions('ga','Display','off');
    
    % We create a set of ga_it elements (obtained by running 
    % ga_it times the genetic algorithm) 
    parfor i = 1:ga_it
        [t, dv_val] = ga(ObjectiveFunction,nvars,A,b,[],[],LB,UB,[],options);
        vect_t(i,:) = t;
        vect_dv(i) = dv_val;
    end
    
    % We evaluate the smallest element of the population
    DV_MIN = min(vect_dv);
    T_DV_MIN = vect_t(vect_dv == DV_MIN,:);
else
    
    % Best result obtained by running the genetic algorithm 100 times
    T_DV_MIN = 1e4*[0.649799190637866, 0.834549018712001, 2.004399559036041];
end

% Outputs DV_min and the position of the planets evaluated at the days 
% founded by the fmincon optimizator
[DV_MIN, r1_arc, r2_arc, r3_arc, v_saturn, dv_ga] = dv_optimizator(T_DV_MIN);

% Evaluate the transfer times for Mars -> Saturn and Saturn -> Neptune
Dv_min_TOF_1 = (T_DV_MIN(2)-T_DV_MIN(1))*86400;
Dv_min_TOF_2 = (T_DV_MIN(3)-T_DV_MIN(2))*86400;

% Day for the best flyby (relative to saturn)
t_saturn = T_DV_MIN(2);

end