function [delta_V,theta_2,theta_3] = anoperichange(a,e,omega_1,omega_2,theta_0,mu_p)

% anoperichange.m
% 
% PROTOTYPE:
%   [delta_V,theta_2,theta_3] = anoperichange(a,e,omega_1,omega_2,theta_0,mu_p)
%
% DESCRIPTION:
% 	This function implements the change of the anomaly of pericenter
%
% INPUT:
%	a[1]           Semimajoraxis first orbit
%   e[1]           Eccentricity first orbit
%   omega_1[1]     Argument of pericenter first orbit
%   omega_2 [2]    Argument of pericenter arrival orbit
%   theta_0[1]     True anomaly of maneuver point
%   mu_p [1]
%
% OUTPUT:
%   delta_V        Delta V reguired in KM\s
%   theta_2        True anomaly of maneuver
%   theta_3        True anomaly after maneuver
%
% AUTHOR:
%   Francescodario Cuzzocrea


delta_omega = abs(omega_2 - omega_1);

p = a*(1-e^2);
delta_V = abs(2*sqrt(mu_p/p)*e*sin(delta_omega/2));

theta_A = delta_omega/2;
theta_B = pi + delta_omega/2; 

if theta_0 > theta_B    
    theta_2 = theta_A;
    theta_3 = 2*pi - theta_A;
else
    theta_2 = theta_B;  
    theta_3 = pi - theta_A;
end

theta_3 = mod(theta_3,2*pi);

end