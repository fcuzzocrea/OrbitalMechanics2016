function [apMG_vect] = Moonper (r_moon_vect,r_vect)
% Moonper.m
% 
% PROTOTYPE:
%   [apMG_vect] = Moonper (r_moon_vect,r_vect))
%
% DESCRIPTION:
% 	This function gives the perturbed acceleration due lunar gravity
% 	influence.
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

mu_moon = 4903;  % Km^3/s^2
r_ms_vect = r_moon_vect - r_vect;

r_ms = norm(r_ms_vect);
r_moon = norm(r_moon_vect);

apMG_vect = mu_moon*(r_ms_vect/r_ms^3 -r_moon_vect/r_moon^3);

