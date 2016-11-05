function [r,v] = par2pos(a,e,i,omega,OMEGA,theta,mu)
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%
% Questa function implementa l'algoritmo necessario per ottenere i vettori (colonna) di posizione 
% e velocità a partire dai parametri orbitali.
% 
% PARAMETRI DI USCITA 			
%
% r			Vettore Posizione
% v			Vettore Velocità
% mu			Parametro gravitazionale
%
% Author : Francescodario Cuzzocrea
% emal : francescodario.cuzzocrea@mail.polimi.it
% (C) 2014

% Il parametro p è noto

p = a*(1 - norm(e)^2);

% Dalla polare è noto R

R = p/(1 + norm(e)*cos(theta));
r_pf = [R*cos(theta);R*sin(theta);0];

% Ricavo la velocità nel sistema di riferimento perifocale

v_pf = [-sqrt(mu/p)*sin(theta); sqrt(mu/p)*(norm(e) + cos(theta)); 0];

% Calcolo le singole matrici di rotazione

OMEGA_ROT = [ cos(OMEGA),sin(OMEGA), 0; -sin(OMEGA), cos(OMEGA), 0; 0, 0, 1];
i_ROT = [1, 0, 0; 0, cos(i), sin(i);  0, -sin(i), cos(i)];
omega_ROT = [cos(omega), sin(omega), 0; -sin(omega), cos(omega), 0; 0, 0, 1];

% Matrice di rotazione completa

T = OMEGA_ROT*i_ROT*omega_ROT;

% Calcolo i vettori posizione e velocità nel sistema di riferimento geocentrico equatoriale

r = T'*r_pf;
v = T'*v_pf;

end


