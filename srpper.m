function [apSRP_vect] = srpper (t)
% Moonper.m
% 
% PROTOTYPE:
%   [apSRP_vect] = srpper (r_moon_vect,r_vect))
%
% DESCRIPTION:
% 	This function gives the perturbed acceleration due to solar radiation
% 	pressure influence.
%
% INPUT:
%	r_moon_vect              Moon position vector
%   r_vect                   Space-craft position vector
%
% OUTPUT:
%   [apMG_vect]              Perturbed acceleration vector     
%   
% AUTHOR:
%   Francescodario Cuzzocrea 
%   Benedetto Lui
%   Alfonso Collogrosso
%

% Sun Mean Motion
n = 2*pi/(60*60*24*365); % rad/s   
% Obliquity of the Ecliptic
eps = deg2rad(23.439);   % rad   

% In GEO frame
sun_direction = [cos(n*t), cos(eps)*sin(n*t), sin(n*t)*sin(eps)];

A_sc = 15;               % m^2
m = 3000;               % Kg

% Useful constants
solar_flux = 1367;        % W/m^2
c = 299792458;            % m/s
C_r = 1.5;                % Radiation pressure coefficient

% WOOST CASE SEENARIOOO
nu = 1;
apSRP = -( nu * (solar_flux/c) * (C_r*A_sc)/m );
apSRP_vect = apSRP * sun_direction;

end